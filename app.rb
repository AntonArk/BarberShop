require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def is_barber_exists? db, barber_name
	db.execute('SELECT * FROM Barbers WHERE barber_name=?', [barber_name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber   # если такого барбера нет
			db.execute 'INSERT INTO Barbers (barber_name) values (?)', [barber]
		end
	end
end

def get_db
    db = SQLite3::Database.new 'BarberShop.db'
    db.results_as_hash = true
    return db
end

before do
	db = get_db
	@barbers = db.execute 'SELECT * from Barbers'
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
	db.execute 'CREATE TABLE IF NOT EXISTS
	    "Barbers" 
	    (
	    	"id"	INTEGER,
			"barber_name"	TEXT,
			PRIMARY KEY("id" AUTOINCREMENT)
		)'
	seed_db db, ['Leia Organa', 'Han Solo', 'Chewbacca', 'Jabba The Hutt']

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