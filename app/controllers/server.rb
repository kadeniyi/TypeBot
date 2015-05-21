require 'sinatra/base'
require 'data_mapper'



DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/typbot.db")

class Typers
  include DataMapper::Resource
  property :id,           Serial
  property :surname,         String, :required => true
  property :firstname,         String, :required => true
  property :email,         String, :required => true
  property :password,         String, :required => true
  property :username,         String, :required => true
  
  has n, :records
end

class Record
  include DataMapper::Resource
  property :id,           Serial
  property :cpm,         Integer
  property :wpm,         Integer
  property :completed_at, DateTime

  belongs_to :typers
end

DataMapper.finalize
DataMapper.auto_upgrade!



class Server < Sinatra::Base
enable :sessions
@@users ="" 
@@highsco = "" 
@@userna =""
@@pass = ""
@@passdb = ""
@@usernam = ""
@high = 0
@highsco1 =""



  get '/' do
  	user = ""
  	session["login"] ||= nil
  	if session["login"] == 1
  		redirect to('/index')
  	else
    	erb :login, :locals => {:user => user}
	end
  end



  get '/index' do
  	der = ""
  	#@highsco = Typers.all(:cpm.not=> nil,:limit => 10, :order => [ :cpm.desc ])

  	@highsco1 = Record.all(:cpm.not=> nil,:limit => 10, :order => [ :cpm.desc ])
  	recx = Hash.new 
  	@recv = Array.new
  	r=0
  	  		@highsco1.each{|recordVal| 

  	  		recx =  {cpm: recordVal.cpm, firstname: recordVal.typers.firstname, lastname: recordVal.typers.surname, wpm: recordVal.wpm }
  	  		@recv << recx
  	  	}



  		@array = Array.new
  		@highsco1.length.times{|u|
  			fev = @highsco1[u].cpm
  			@array << fev
  		}

  	@high = @array.min

  	n =0
  	if session['login'] == 1
  		#der = @highsco1
	  	quest = ["The World is a stage", "Life is all about change", "Andela is a place to be", "The two weeks training is enough to change your life"]
	    user = @@usernam[0]
	    erb :index, :locals => {:user => user, :quest => quest, :highscore => @recv, :n => n}
	else
		redirect to('/')
	end
  end

  get '/logout' do
  	session['login'] = nil
  	@@users = ""
    redirect to('/')
  end

  post '/' do
  	@@pass = params[:password]
  	@@userna = params[:username]
  	@@usernam = Typers.all(:username => params[:username])
  	
  if @@usernam.length != 0
		  if params[:username] == @@usernam[0].username && params[:password] == @@usernam[0].password
		  	@@users = @@usernam[0].username
		  	session['login'] = 1
		  	session['uid'] = @@usernam[0].id
		  	@@passdb = @@usernam[0].password
		  redirect to('/index')
		  else
			user = "Username and Password mismatch"
  			erb :login, :locals => {:user => user}
		  end
  else
  	user = "Wrong Credentials"
  	erb :login, :locals => {:user => user}
  end

 end

 get '/signup' do
    erb :signup
  end

  post '/signup' do
  	@@pass = params[:password]
  	@@userna = params[:username]
  	@@usernam = Typers.all(:username => params[:username])
  if !@@usernam.include?@@userna
  	Typers.create(surname:params[:surname], firstname:params[:firstname],email:params[:email],password:params[:password],username:params[:username])
  	@@users = params[:username]
  	@@passdb = params[:password]
  redirect to('/index')
  else
  	user = "Username has been taken, try another!"
  	erb :signup, :locals => {:user => user}
  end
 end

post '/submit' do

  	if session["login"] != 1
  		redirect to('/index')
  	else
  		Record.create(:cpm => params[:bar].to_i, :wpm => params[:bar2].to_i, :completed_at => Time.now, :typers_id => session['uid'])

  		@highsco1 = Record.all(:cpm.not=> nil,:limit => 10, :order => [ :cpm.desc ])
		  	recx = Hash.new 
		  	@recv = Array.new
  
  	  		@highsco1.each{|recordVal| 

  	  		recx =  {cpm: recordVal.cpm, firstname: recordVal.typers.firstname, lastname: recordVal.typers.surname, wpm: recordVal.wpm }
  	  		@recv << recx
  	  	}

    	return "Your score #{params[:bar]}CPM, #{params[:bar2]}WPM  has been saved to your profile"
	end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end