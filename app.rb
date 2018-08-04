require 'sinatra'
require_relative 'tictactoe'

enable :sessions

get '/' do
  session[:gameobj] = GameBoard.new
  session[:player1] = "Human"
  session[:player2] = "Unbeatable"
  erb :newgame
end

post '/turn' do
  cur_board = session[:gameobj]
  p2 = UnbeatablePlayer.new
  p2.piece = "X"
  p2.enemy_piece = "O"
  p2.set_board(cur_board)

  player_move = params[:tile_clicked].split("_")
  if cur_board.get_tile(player_move[0].to_i, player_move[1].to_i) == 0
    cur_board.set_tile(player_move[0].to_i, player_move[1].to_i, "O")
    p2.take_turn()
  end
  session[:gameobj] = cur_board

  if cur_board.check_winner()
    redirect '/end_game'
  else
    redirect '/next_move'
  end
end

get '/next_move' do
  erb :next_move, locals: {game_inst: session[:gameobj]}
end

get '/end_game' do
  cur_board = session[:gameobj]
  winner = cur_board.check_winner();
  erb :end_game, locals: {game_inst: session[:gameobj], victor: winner}, trim: '-'
end