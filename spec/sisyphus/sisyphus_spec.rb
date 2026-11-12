require 'spec_helper'

module Sisyphus
	describe ".print" do
		subject {Sisyphus.print(obj) }
		let(:obj){ MedusaRestClient::Stone.new("global_id" => stone_gid, "name" => stone_name) }
		let(:stone_gid){ '0000-0012'}
		let(:stone_name){ 'deleteme-stone'}
		let(:uri){ double(:uri) }
		it {
			#expect(nil).to be_nil
			#expect{Sisyphus.print(obj)}.not_to raise_error
			expect(URI).to receive(:parse).with("http://localhost:8889/Format/Print?UID=#{stone_gid}&NAME=#{stone_name}").and_return(uri)
			expect(Net::HTTP).to receive(:get_response).with(uri)
			subject
		}
	end
end
