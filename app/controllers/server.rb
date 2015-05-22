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

  	@highsco1 = Record.all(:wpm.not=> nil,:limit => 10, :order => [ :wpm.desc ])
  	recx = Hash.new 
  	@recv = Array.new
  	r=0
  	  		@highsco1.each{|recordVal| 

  	  		recx =  {cpm: recordVal.cpm, firstname: recordVal.typers.firstname, lastname: recordVal.typers.surname, wpm: recordVal.wpm }
  	  		@recv << recx
  	  	}



  		@array = Array.new
  		@highsco1.length.times{|u|
  			fev = @highsco1[u].wpm
  			@array << fev
  		}

  	@high = @array.min

  	n =0
  	if session['login'] == 1
  		#der = @highsco1
	  	quest = ["Little Trisha is overjoyed at the thought of starting school and learning how to read. But right from the start, when she tries to read, all the letters and numbers just get jumbled up. Her classmates make matters worse by calling her dummy and toad", "Boxing is a permissible brutality, it brings bread a million and it elevates one from the seat of obscurity to the hall of fame", "Chester and Wilson had their own way of doing things, and they did everything together. When they cut their sandwiches, it was always diagonally. When they rode their bikes, they always used hand signals. If Chester was hungry, Wilson was too. They were two of a kind, and that’s the way it was until indomitable Lilly, who had her own way of doing things, moved into the neighborhood", "Ethan is a little boy who can’t fall asleep without the ragged breathing and claw-scratching of his favorite monster, Gabe. But Gabe has left a note that he’s gone fishing, so Ethan knocks on his floor to summon a series of substitute ghoulies","Romeow the cat and Drooliet the dog are two star-crossed lovers who meet by chance, marry in secret and are kept apart by a snarling rottweiler, appalled owners and the animal control warden","One evening, when the King is in a hurry, his goodnight kiss to the Little Prince goes astray. After rattling around the Prince’s bedroom, it flies out the window and floats into the dark forest, where it has no business to be. The King decides to do something about it. He orders the Knight to climb on his horse, ride into the forest, and bring back the kiss. But the forest is filled with spooky things that frighten both the Knight and his horse. How will they ever succeed in bringing the kiss back to the castle?","If there was anything in the world better than playing baseball, Marcenia Lyle didn’t know what it was. As a young girl in the 1930s, she chased down fly balls and stole bases, and dreamed of one day playing professional ball","With spirit, spunk, and a great passion for the sport, Marcenia struggled to overcome the objections of family, friends, and coaches, who felt a girl had no place in the field. When she finally won a position in a baseball summer camp sponsored by the St. Louis Cardinals, Marcenia was on her way to catching her dream","Full of warmth and youthful energy, Catching the Moon is the story of the girl who grew up to become the first woman to play for an all-male professional baseball team. Readers everywhere will be inspired by her courage to dream and determination to succeed"]
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

  		@highsco1 = Record.all(:wpm.not=> nil,:limit => 10, :order => [ :wpm.desc ])
		  	recx = Hash.new 
		  	@recv = Array.new
  
  	  		@highsco1.each{|recordVal| 

  	  		recx =  {cpm: recordVal.cpm, firstname: recordVal.typers.firstname, lastname: recordVal.typers.surname, wpm: recordVal.wpm }
  	  		@recv << recx
  	  	}

    	return "Your score #{params[:bar2]}WPM  has been saved to your profile"
	end
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end