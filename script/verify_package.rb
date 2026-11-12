require 'open3'
require 'rbconfig'
require 'rubygems/package'
require 'tmpdir'
require_relative '../lib/sisyphus/version'

archive = File.expand_path(ARGV.fetch(0))
package = Gem::Package.new(archive)
package.verify
spec = package.spec
abort 'Unexpected gem name or version' unless spec.name == 'sisyphus-for-medusa' && spec.version.to_s == Sisyphus::VERSION
abort 'Archive filename does not match its metadata' unless File.basename(archive) == spec.file_name

Dir.mktmpdir('sisyphus-package-') do |directory|
  gem_home = File.join(directory, 'gems')
  environment = {
    'HOME' => directory,
    'GEM_HOME' => gem_home,
    'GEM_PATH' => ([gem_home] + Gem.path).join(File::PATH_SEPARATOR),
    'RUBYLIB' => nil,
    'RUBYOPT' => nil
  }
  File.write(File.join(directory, '.orochirc'), "uri: https://medusa.invalid/\nuser: test\npassword: test\n")
  run = lambda do |*args|
    stdout, stderr, status = Open3.capture3(environment, RbConfig.ruby, *args, chdir: directory)
    abort "Command failed (#{status.exitstatus}): #{args.inspect}\n#{stdout}\n#{stderr}" unless status.success?
    stdout
  end

  run.call('-rrubygems/gem_runner', '-e', 'Gem::GemRunner.new.run(ARGV)', '--',
           'install', '--local', '--no-document', '--ignore-dependencies', archive)
  executable = File.join(gem_home, 'bin', 'sisyphus')
  version = "_#{spec.version}_"
  help = run.call(executable, version, '--help')
  abort "Unexpected usage line: #{help.lines.first.inspect}" unless help.lines.first&.chomp == 'Usage: sisyphus [options]'
  %w[--port --title --print-timeout --help].each do |option|
    abort "Missing option in installed CLI help: #{option}" unless help.include?(option)
  end
  abort 'Short and long help flags show different output' unless run.call(executable, version, '-h') == help
  error = run.call(executable, version, '--not-an-option')
  abort "Missing help hint after an invalid option: #{error}" unless error.include?("See 'sisyphus --help'.")

  run.call('-e', <<~'RUBY', spec.name, spec.version.to_s, gem_home)
    name, version, gem_home = ARGV
    gem name, "= #{version}"
    require 'sisyphus/server'
    require 'rack/mock'

    installed = Gem.loaded_specs.fetch(name)
    abort 'Sisyphus loaded from outside the temporary installation' unless File.realpath(installed.base_dir) == File.realpath(gem_home)

    Sisyphus::Server.send(:detect_rack_handler)
    browser = Rack::MockRequest.new(Sisyphus::Server)
    title = '三朝 試料'
    Sisyphus.title = title.encode(Encoding::Windows_31J)
    response = browser.get('/')
    abort "GET / returned #{response.status}" unless response.status == 200
    body = response.body.b.force_encoding(Encoding::UTF_8)
    unless response['Content-Type'].match?(/charset=utf-8/i) && body.valid_encoding? && body.include?("<title>#{title}</title>")
      abort 'GET / did not render the Windows-encoded title as UTF-8'
    end
    abort 'The specimen form is missing from GET /' unless body.include?('name="stone[name]"')

    specimen_id = '0000-0012'
    specimen_name = '三朝 A+B & #1'
    specimen_class = Struct.new(:global_id, :name) do
      def save
        true
      end
    end
    MedusaRestClient::Specimen.define_singleton_method(:new) do |attributes|
      specimen_class.new(specimen_id, attributes.fetch('name'))
    end
    print_uri = nil
    Net::HTTP.define_singleton_method(:get_response) { |uri| print_uri = uri }
    form = "--fixture\r\nContent-Disposition: form-data; name=\"stone[name]\"\r\n\r\n#{specimen_name}\r\n--fixture--\r\n"
    response = browser.post('/', 'CONTENT_TYPE' => 'multipart/form-data; boundary=fixture', input: form)
    abort "POST / returned #{response.status}" unless response.status == 302
    abort 'POST / did not send a print request' unless print_uri && print_uri.path == '/Format/Print'
    unless URI.decode_www_form(print_uri.query).to_h == {'UID' => specimen_id, 'NAME' => specimen_name}
      abort 'The print request changed the specimen ID or name'
    end
  RUBY
end

puts "PASS #{spec.full_name}: archive, CLI help, server handler, UTF-8 page and print request (Ruby #{RUBY_VERSION})"
