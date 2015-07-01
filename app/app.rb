require 'sinatra/base'
require './app/data_mapper_setup.rb'
require 'pry'

class BookmarkManager < Sinatra::Base
  # set :views, proc { File.join('app/views') }
  run! if app_file == $0
  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    redirect 'links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url],
                title: params[:title],)
    tags  = params[:tags].split
    tags.each do |tag|
      link.tags << Tag.create(name: tag)
    end
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    user = User.create(email: params[:email],
                password: params[:password])
    session[:user_id] = user.id
    redirect to('/')
  end

  helpers do
    def current_user
      current_user = User.get(session[:user_id])
    end
  end
end
