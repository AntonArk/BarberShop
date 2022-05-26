require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  return SQLite3::Database.new 'BarberShop.db'
end

configure do 
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
	    "Users" 
	    (
	    	"id"	INTEGER,
			"username"	TEXT,
			"phone"	TEXT,
			"date_stamp"	TEXT,
			"barber"	TEXT,
			"colour"	TEXT,
			PRIMARY KEY("id" AUTOINCREMENT)
		)'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]
	@barber = params[:barber]
	@colour = params[:colour]

	# хеш
	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
			:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'INSERT INTO
		Users
		(
			username,
			phone,
			date_stamp,
			barber,
			colour

		)
		values (?,?,?,?,?)',
		[@username, @phone, @datetime, @barber, @colour]

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@colour}"

end
