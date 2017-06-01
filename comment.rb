require 'data_mapper'

class CommentData
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :comment,   String,  :required => true,:length => 500
  property :created_at, DateTime
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/comments' do
  @comments = CommentData.all
  erb :comments
end


get '/comments/new' do
  if session[:admin]
    @comment = CommentData.new
    @comment.created_at = Time.now
    erb :new_comment
  else
    erb :ask_login
  end
end

get '/comments/:id' do
  if session[:admin]
    @comment = CommentData.get(params[:id])
    erb :show_comment
  else
    erb :ask_login
  end
end

post '/comments' do
  comment = CommentData.create params[:comment]
  puts params[:comment]
  redirect to("/comments/#{comment.id}")
end

put '/comments/:id' do
  comment = CommentData.get(params[:id])
  comment.update(params[:comment])
  redirect to("/comments/#{comment.id}")
end

