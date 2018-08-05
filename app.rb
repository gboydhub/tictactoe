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
  if !session[:gameobj]
    redirect '/'
  end
  cur_board = session[:gameobj]

  player_move = params[:tile_clicked].split("_")
  if cur_board.get_tile(player_move[0].to_i, player_move[1].to_i) == 0
    cur_board.set_tile(player_move[0].to_i, player_move[1].to_i, "O")
  end
  session[:gameobj] = cur_board

  if cur_board.check_winner()
    redirect '/end_game'
  else
    redirect '/next_move'
  end
end

post '/new_game' do
  session[:gameobj] = GameBoard.new
  session[:player1] = "Human"
  session[:player2] = "Human" #Default players to human to catch wonky form data

  if params[:p1_type] == "ai" #X is pirate
    case params[:comp1_difficulty]
    when "1"
      session[:player1] = RandomPlayer.new
    when "2"
      session[:player1] = SequentialPlayer.new
    when "3"
      session[:player1] = UnbeatablePlayer.new
    end
    session[:player1].piece = "X"
    session[:player1].enemy_piece = "O"
    session[:player1].set_board(session[:gameobj])
  end
  
  if params[:p2_type] == "ai" #O is ninja
    case params[:comp2_difficulty]
    when "1"
      session[:player2] = RandomPlayer.new
    when "2"
      session[:player2] = SequentialPlayer.new
    when "3"
      session[:player2] = UnbeatablePlayer.new
    end
    session[:player2].piece = "O"
    session[:player2].enemy_piece = "X"
    session[:player2].set_board(session[:gameobj])
  end


end

get '/next_move' do
  if !session[:gameobj]
    redirect '/'
  end

  game_board = session[:gameobj]
  if game_board.turns_taken % 2 == 0 #Ninja's go first (Duh)
    if session[:player2] != "Human"
      session[:player2].take_turn()
    end
  else
    if session[:player1] != "Human"
      session[:player1].take_turn()
    end
  end
  if session[:gameobj].check_winner()
    redirect '/end_game'
  end

  erb :next_move, locals: {game_inst: session[:gameobj]}
end

get '/end_game' do
  if !session[:gameobj]
    redirect '/'
  end
  
  cur_board = session[:gameobj]
  winner = cur_board.check_winner();
  erb :end_game, locals: {game_inst: session[:gameobj], victor: winner}, trim: '-'
end