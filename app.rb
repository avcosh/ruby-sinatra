require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'

get '/' do
    erb "Hello"
end

get '/about' do
    erb 'All about us'
end

get '/sign' do
    erb :sign
end

post '/sign' do
    @name = params[:name]
	@email = params[:email]
	@date = params[:date]
	@barber = params[:barber]
	
	
	
	hh = { :name => 'Enter name',
	       :email => 'Enter email',
		   :date => 'Enter date',
		   :barber => 'Enter barber'}
	
	#hh.each do |key, value|
	#    if params[key] == ''
	#	    @error = hh[key]
	#		return erb :sign
	#	end
	#end
	
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
	
	file = File.open "./public/clients.txt", "a"
	file.write "Name: #{@name}, mail: #{@email}, date: #{@date}, barber: #{@barber}.\n"
	file.close
	
	erb "Your data: #{@name}, #{@date}, #{@barber}"
end

get '/contacts' do
    erb :contacts
end

post '/contacts' do
    @email = params[:email]
	@text = params[:text]
	
	hh = { 
	       :email => 'Enter email',
		   :text => 'Enter text',
		 }
	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")
	
	Pony.mail(:to => 'ksenon-spb@mail.ru', :from => "#{@email}", :subject => "test", :body => "#{@text}")
	
	file = File.open "./public/contacts.txt", "a"
	file.write "mail: #{@email}, text: #{@text}.\n"
	file.close
	
	erb "Thank for contact"
	
end

get '/login' do
    erb :login
end

post '/login' do
    @login = params[:login]
	@password = params[:password]
    
    if @login == 'admin' && @password == 'secret'
	    @file = File.open "./public/clients.txt", "r"
	    erb :admin
    else
	    erb "Access denied"
    end	
end
