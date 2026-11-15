require 'spec_helper'
require 'sisyphus'
require 'sisyphus/server'
require 'rack/test'
require 'medusa_rest_client'
#require 'tepra'

module Sisyphus
	describe Server do
		include Rack::Test::Methods

		def app
			Sisyphus::Server
		end

		it 'renders the specimen form without template adapter warnings' do
			expect { get '/' }.not_to output.to_stderr
			expect(last_response).to be_ok
			expect(last_response.body).to match(/<nav\b/)
			expect(last_response.body).to match(/<form\b/)
			expect(last_response.body).to include('stone[name]')
			expect(last_response.body).to match(/type=['"]file['"]/)
			expect(last_response.body).not_to match(/&lt;(nav|form)\b/)
		end

		describe "post '/'" do

			context "without params" do
				#let(:params){{}}
				before do
					post '/'
				end
				it { 
					expect(last_response).to be_redirect
					expect(last_response.location).to include('/')
				}

			end

			context "with params", :current => true do
				let(:stone_obj){ MedusaRestClient::Stone.new(stone_param.merge("global_id" => stone_gid)) }
				let(:file_obj){ MedusaRestClient::AttachmentFile.new(file_param.merge("global_id" => '0000-002')) }
				let(:params){{"stone" => stone_param, "file" => post_file}}
				let(:stone_param){ { "name" => name } }
				let(:file_param){ { "name" => filename }}
				let(:stone_gid){ '0000-0012'}
				let(:stone_id){ 100 }
				let(:name){ '5K2345' }
				let(:post_file){ Rack::Test::UploadedFile.new(file_path)}
				let(:file_path){ file_path_for(filename) }
				let(:filename){'Desert.jpg'}

				before do
			#		FakeWeb.allow_net_connect = false					
					#MedusaRestClient::Specimen = double("MedusaRestClient::Specimen")
					#MedusaRestClient::Specimen.stub(:new).with(stone_param).and_return(stone_obj)
					allow(MedusaRestClient::Specimen).to receive(:new).and_return(stone_obj)
					stone_obj.stub(:save).and_return(true)
					stone_obj.stub(:upload_file).and_return(file_obj)
					allow(Sisyphus).to receive(:print)
				end

				def do_post
					post '/', params
				end

				it { 
					do_post
					expect(last_response).to be_redirect
					expect(last_response.location).to include('/')
				}

				xit "should call Tepra.print with label_string" do
					expect(Sisyphus).to receive(:print)
					#expect(Tepra).to receive(:print).with("#{stone_obj.global_id},\"#{stone_obj.name}\"", {:timeout => Sisyphus.print_timeout}).and_return(true)
					post '/', params
				end
			end
		end

		describe "get '/'" do
			before do
				get '/'
			end

			context "without params" do
				it { expect(last_response).to be_ok }
			end

			context "with params" do
				it { expect(last_response).to be_ok }
			end

		end

	end
end
