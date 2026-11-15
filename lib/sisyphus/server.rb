module Sisyphus
	require 'sisyphus'
	require 'sinatra/base'
	require 'sinatra/reloader'
	# Let Haml register its own Tilt adapter before Sinatra renders a view.
	require 'haml'
	require 'medusa_rest_client'
#	require 'tepra'
	MedusaRestClient::Base.init

	class Server < Sinatra::Base
		configure :test do
			register Sinatra::Reloader
			set :raise_errors, true
			set :show_exceptions, false
		end
		configure :development do
			register Sinatra::Reloader
			set :raise_errors, true
			set :show_exceptions, false
		end
		get '/' do
			haml :index
			#'hello world'
		end

		post '/' do
			file = params.delete("file")
			stone_params = params[:stone]
			if stone_params
				stone = MedusaRestClient::Specimen.new(stone_params)
				if stone.save
					label_string = "#{stone.global_id},\"#{stone.name}\""
					if file
						filename = file[:filename]
						path = file[:tempfile].path
						stone.upload_file(:file => path, :filename => filename)
					end
					begin
						Sisyphus.print(stone)
					rescue
					end
					#Tepra.print(label_string, :timeout => Sisyphus.print_timeout)
				end
			end
			redirect '/'
		end

		run! if app_file == $0
	end

end
