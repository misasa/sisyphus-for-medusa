require 'rubygems'
#require 'spork'
#require 'simplecov'
#require 'simplecov-rcov'
#SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
#SimpleCov.start

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

#Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
#  require 'rspec'
#  require 'turnip'
  require 'factory_girl'
  require 'fakeweb'
  require 'fakeweb_matcher'
  require 'sinatra'
  #require 'sinatra/base'
  require 'sinatra/reloader'

  require 'medusa_rest_client'
#  require 'tepra'

  FactoryGirl.find_definitions

#end

#Spork.each_run do
  # This code will be run each time you run your specs.
  #require 'sisyphus'
#end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.




#Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }

def file_path_for(filename)
	path = Pathname.new(File.dirname(__FILE__)) + 'fixtures/files' + filename
	path.to_s
end


RSpec.configure do |config|
 	config.mock_with :rspec do |c|
 		c.syntax = [:should, :expect]
 	end
 	config.expect_with :rspec do |c|
 		c.syntax = [:should, :expect]
 	end
# 	config.deprecation_stream = 'log/deprecations.log'
# 	config.backtrace_exclusion_patterns = []
end