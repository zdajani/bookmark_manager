require 'sinatra/base'
require './app/data_mapper_setup.rb'
require 'pry'

class BookmarkManager < Sinatra::Base
  set :views, proc { File.join('app/views') }
  run! if app_file == $0

  get '/' do
    redirect 'links'
  end

  get '/links' do
    @links = Link.all
    @tags = Tag.all
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

end
