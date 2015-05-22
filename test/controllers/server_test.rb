ENV["RACK_ENV"] ||= "test"

require 'bundler'
Bundler.require

require_relative "../../config/environment"
require 'minitest/autorun'
require 'rack/test'

class MyAppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Server
  end

  def test_root
    get '/'
    assert_equal 200, last_response.status
  end

  def test_logout
    get '/logout'
    assert_equal 302, last_response.status
  end

  def test_signup
    get '/signup'
    assert_equal 200, last_response.status
  end

  def test_submit
    get '/submit' :session[login]=>0
    assert_equal 200, last_response.status
  end
  
end