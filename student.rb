require 'data_mapper'

class StudentData
  include DataMapper::Resource
  property :id, Serial
  property :sfname, String
  property :slname, String
  property :major, String
  property :gpa, Float, :default => 0
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
  @students = StudentData.all
  erb :students
end

get '/students/new' do
  if session[:admin]
    @student = StudentData.new
    erb :new_student
  else 
    erb :ask_login
  end
end

get '/students/:id' do 
  if session[:admin]
    @student = StudentData.get(params[:id])
    erb :show_student
  else
    erb :ask_login
  end
end

get '/students/:id/edit' do
  if session[:admin]
    @student = StudentData.get(params[:id])
    erb :edit_student
  else
    erb :ask_login
  end
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
