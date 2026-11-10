require 'sisyphus/command'
require 'sisyphus/server'

class Sisyphus::Commands::ServerCommand < Sisyphus::Command
	def initialize
		super '', 'Start the Sisyphus web server', :port => 8890, :bind => '0.0.0.0', :title => 'Sisyphus', :print_timeout => 10

		OptionParser.accept :Port do |port|
			if port =~ /\A\d+\z/ then
				port = Integer port
				raise OptionParser::InvalidArgument, "#{port}: not a port number" if
				port > 65535
				port
			else
				begin
					Socket.getservbyname port
				rescue SocketError
					raise OptionParser::InvalidArgument, "#{port}: no such named service"
				end
			end
		end

		add_option '-p', '--port=PORT', :Port, 'Set the HTTP port (default: 8890)' do |port, options|
			options[:port] = port
		end

		add_option '-t', '--title=TITLE', 'Set the title shown in the web interface' do |title, options|
			options[:title] = title
		end

		add_option '-o', '--print-timeout=TIME', 'Set the legacy print timeout value' do |time, options|
			options[:print_timeout] = time.to_i
		end

#		add_option '-b', '--bind=HOST,HOST','addresses to bind', Array do |address, options|
#			options[:bind] ||= []
#			options[:bind].push(*address)
#		end

	end

	def description
		<<-EOF
Use Sisyphus to create specimen records in Medusa and print barcode
labels from a browser on this computer or another computer on the
network. By default, the web interface is at http://localhost:8890 on
the computer running Sisyphus.

Barcode labels are sent to a Windows print service on the computer
running Sisyphus. The current HTTP print request ignores the legacy
--print-timeout setting.

Examples:
    sisyphus
    sisyphus --port=8891 --title="Medusa specimens"

See also:
    http://dream.misasa.okayama-u.ac.jp

History:
    August 11, 2018: TK added the documentation.

Implementation:
    Copyright (C) 2015-2020 Okayama University
    License GPLv3+: GNU GPL version 3 or later

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3, or (at your option)
    any later version.

EOF
	end

    def execute
		args = options.delete(:args)
		build_args = options.delete(:build_args)
		title = options.delete(:title)
		Sisyphus.title = title if title
		print_timeout = options.delete(:print_timeout)
		Sisyphus.print_timeout = print_timeout if print_timeout
		app_url = "http://localhost:#{options[:port]}"
		launch_cmd = "#{Sisyphus.open_command} #{app_url}"
		Sisyphus.execute_command(launch_cmd)
		run_server(options)
		#Sisyphus::Server.run! options
	end

	def run_server(options)
		Sisyphus::Server.run! options
	end
end
