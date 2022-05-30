require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
    db = SQLite3::Database.new 'BarberShop.db'
    db.results_as_hash = true
    return db
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
	db.close
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
        db.close

	erb "OK, username is #{@username}, #{@phone}, #{@datetime}, #{@barber}, #{@colour}"

end

get '/showusers' do
	db = get_db

    @results = db.execute 'SELECT * FROM Users ORDER BY id ASC'

	erb :showusers
end