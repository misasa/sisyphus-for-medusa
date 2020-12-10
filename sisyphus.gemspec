# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sisyphus/version'

Gem::Specification.new do |spec|
  spec.name          = "sisyphus-for-medusa"
  spec.version       = Sisyphus::VERSION
  spec.authors       = ["Yusuke Yachi"]
  spec.email         = ["yyachi@misasa.okayama-u.ac.jp"]
  spec.summary       = %q{GUI client application for Medusa.}
  spec.description   = %q{This is a GUI client application for Medusa.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency('sinatra', "~> 1.4")
  spec.add_dependency('sinatra-contrib', "~> 1.4")
  spec.add_dependency('haml', ">= 5.0.0")
#  spec.add_dependency('thin', "~> 1.6")  

  spec.add_dependency('medusa_rest_client', "~> 0.1")
#  spec.add_dependency('tepra', "0.0.3")

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "2.14"
#  spec.add_development_dependency "turnip", "~> 1.2"  
  spec.add_development_dependency "rack-test", "~> 0.0"
  spec.add_development_dependency "factory_girl", "~> 4.4"
  spec.add_development_dependency "fakeweb", "~> 1.3"
  spec.add_development_dependency "fakeweb-matcher", "~> 1.2"
#  spec.add_development_dependency "google-protobuf"
#  spec.add_development_dependency "spork", "~> 0.9"
  #spec.add_development_dependency "guard-rspec", "~> 4.3"
#  spec.add_development_dependency "simplecov-rcov", "~> 0.2.3"
#  spec.add_development_dependency "rspec_junit_formatter", "~> 0.2.0"    
end
