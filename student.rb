require 'dm-core'
require 'dm-migrations'
require 'dm-validations'

class StudentData
  include DataMapper::Resource
  property :id, Serial
  property :sfname, String,:default => "FNU"
  property :slname, String,:default => "FNU"
  property :major, String,:required => true
  property :gpa, Float
  property :birthday, Date
  property :address, String
  property :studentid, String
end

configure do
  enable :sessions
  set :username, 'frank'
  set :password, 'sinatra'
end

DataMapper.finalize

get '/students' do
  if session[:admin]
    @students = StudentData.all
    erb :students
  else
    erb :ask_login
  end
end

get '/students/new' do
  halt(401,'Not Authorized') unless session[:admin]
  @student = StudentData.new
  erb :new_student
end

get '/students/:id' do
  @student = StudentData.get(params[:id])
  erb :show_student
end

get '/students/:id/edit' do
  @student = StudentData.get(params[:id])
  erb :edit_student
end

post '/students' do  
  student = StudentData.create params[:student]
  puts params[:student]
  redirect to("/students/#{student.id}")
end

post '/login' do
  if (params[:username] == settings.username && params[:password] == settings.password)
    session[:admin] = true
    erb :home
  else
    erb :try_again
  end
end

put '/students/:id' do
  student = StudentData.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  StudentData.get(params[:id]).destroy
  redirect to('/students')
end
