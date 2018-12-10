require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
	@all_files = Dir.entries('public')
	@parameters = params

	@all_files.reverse! if @parameters[:sort] == 'desc'
		
	erb :main
end
