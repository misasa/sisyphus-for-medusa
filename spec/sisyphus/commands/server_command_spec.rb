require 'spec_helper'
require 'sisyphus'
require 'sisyphus/commands/server_command'
module Sisyphus::Commands
	describe ServerCommand do
		describe "#handle_options" do
			#subject { cmd.handle_options args}
			let(:cmd){ ServerCommand.new }
			let(:args){ ["-h", "--port", "#{port}", "--title", title, "--print-timeout", "#{timeout}"] }
			let(:port){ 1212 }
			let(:title){ 'Dream'}
			let(:timeout){ 20 }
			before do
				cmd.handle_options args
				puts cmd.show_help
			end
			it { expect(cmd.options).to include(:port => port)  }
			it { expect(cmd.options).to include(:bind => '0.0.0.0') }
			it { expect(cmd.options).to include(:title => title)}
			it { expect(cmd.options).to include(:print_timeout => timeout)}			
		end

		describe "#execute" do
			subject { cmd.execute }
			let(:cmd) { ServerCommand.new }
			before do

				cmd.stub(:options).and_return(options)
#				Sisyphus::Server = double("Sisyphus::Server")
				allow(cmd).to receive(:run_server)
				allow(Sisyphus).to receive(:execute_command).and_return(true)
				allow(Sisyphus).to receive(:open_command).and_return('ooopen')
			end

			context "with option" do
				let(:options) { {:title => title, :print_timeout => timeout, :port => port, :bind => bind} }
				let(:title){ 'Dream of HACTO' }
				let(:timeout){ 30 }
				let(:port){ 8890 }
				let(:bind){ '0.0.0.0' }
				#before do
				#	Sisyphus.config = { }
				#end
				it { 
					expect{subject}.not_to raise_error 
					expect(Sisyphus.title).to eql(title)
					expect(Sisyphus.print_timeout).to eql(timeout)
				}

				it "should call Sisyphus.system" do
					expect(Sisyphus).to receive(:execute_command).with("#{Sisyphus.open_command} http://localhost:#{port}").and_return(true)
					cmd.execute
				end

				it "should call Sisyphus::Server.run!" do
					expect(cmd).to receive(:run_server).with({:port => port, :bind => bind })
					cmd.execute
				end

			end

		end		
	end
end
