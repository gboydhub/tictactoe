require 'sinatra'
require_relative 'tictactoe'

enable :sessions

get '/' do
  erb :newgame
end