require 'sinatra/base'
require './app/data_mapper_setup.rb'
require 'pry'

class BookmarkManager < Sinatra::Base
  set :views, proc { File.join('app/views') }
  run! if app_file == $0

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    Link.create(url: params[:url], title: params[:title])
    redirect to('/links')
  end

end
