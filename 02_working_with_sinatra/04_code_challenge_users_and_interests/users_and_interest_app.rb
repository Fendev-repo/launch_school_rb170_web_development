require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'yaml'
require 'pry-byebug'

before do
  @users = YAML.load_file('data/users.yml')
end

helpers do
  def pagination_status_class(user)
    return 'waves-effect' if params.empty?

    params_name = params['name'].to_sym
    params_name == user.first ? 'active' : 'waves-effect'
  end

  def first_name(user)
    user.first.to_s.capitalize
  end

  def link(user)
    "/user/#{user.first}"
  end

  def count(item)
    interest_count = 0

    @users.each do |user|
      interest_count += user[1][:interests].count
    end

    case item
    when :users then @users.count
    when :interests then interest_count
    end
  end
end

not_found do
  redirect '/'
end

get '/user/:name' do
  @name = params[:name] unless params.nil?
  @user_profile = @users[@name.to_sym]

  erb :user
end

get '/' do
  erb :home
end
