require 'rubygems'
require 'sinatra'
require 'data_mapper'

#database set up
DataMapper::setup(:default,"sqlite3://#{Dir.pwd}/DontForget.db")

class Note
	include DataMapper::Resource
	property :id, Serial
	property :content, Text, :required => true
	property :complete, Boolean, :required => true, :default => false
	property :created_at, DateTime
	property :updated_at, DateTime
end

DataMapper.finalize.auto_upgrade!

#ROUTES

#root
 get '/' do
 	@notes = Note.all :order => :id.desc
 	@title = 'All Notes'
 	erb :home 	
 end

post '/' do
  n = Note.new
  n.content = params[:content]
  n.created_at = Time.now
  n.updated_at = Time.now
  n.save
  redirect '/'
end

 get '/:id' do
 	@note = Note.get params[:id]
 	@title = "Edit note ##{params[:id]}"
 	erb :edit 
 end

put '/:id' do
  n = Note.get params[:id]
  n.content = params[:content]
  n.complete = params[:complete] ? 1 : 0
  n.updated_at = Time.now
  n.save
  redirect '/'
end

get '/:id/delete' do
	@note = Note.get params[:id]
	@title = "Confirm deletion of note ##{params[:id]}" 
	erb :delete
end

delete '/:id' do
	n = Note.get params[:id]
	n.destroy
	redirect '/'
end

get '/:id/complete' do
	n = Note.get params[:id]
	n.updated_at = Time.now

	if n.complete == false
		n.complete = true
	else
		n.complete = false
	end
	n.save
	redirect '/'
	
end
