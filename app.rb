require 'sinatra'
require_relative 'tictactoe'

enable :sessions

get '/' do
  session[:gameobj] = nil
  session[:player1] = nil
  session[:player2] = nil
  session[:secret] = "false"
  erb :newgame
end

post '/turn' do
  if !session[:gameobj]
    redirect '/'
  end

  cur_piece = "O"
  if session[:gameobj].turns_taken % 2 == 0
    if session[:player2] != "Human"
      redirect '/next_move'
    end
  else
    if session[:player1] != "Human"
      redirect '/next_move'
    end
    cur_piece = "X"
  end
  
  player_move = params[:tile_clicked].split("_")
  if session[:gameobj].get_tile(player_move[0].to_i, player_move[1].to_i) == 0
    session[:gameobj].set_tile(player_move[0].to_i, player_move[1].to_i, cur_piece)
  end

  if session[:gameobj].check_winner()
    redirect '/end_game'
  else
    redirect '/next_move'
  end
end

post '/new_game' do
  board_size = params[:board_size] || "1"

  session[:gameobj] = GameBoard.new(1 + (board_size.to_i * 2))
  session[:player1] = "Human"
  session[:player2] = "Human" #Default players to human to catch wonky form data

  if params[:eggy] == "true"
    session[:secret] = "true"
  end

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

  redirect '/next_move'
end

post '/reset_game' do
  if !session[:gameobj]
    redirect '/'
  end

  board_size = params[:board_size] || "3"
  session[:gameobj] = GameBoard.new(board_size.to_i);
  if session[:player1] != "Human"
    session[:player1].set_board(session[:gameobj])
  end
  if session[:player2] != "Human"
    session[:player2].set_board(session[:gameobj])
  end
  redirect '/next_move'
end

get '/next_move' do
  if !session[:gameobj]
    redirect '/'
  end

  human_turn = true
  if session[:gameobj].turns_taken % 2 == 0 #Ninja's go first (Duh)
    if session[:player2] != "Human"
      session[:player2].take_turn()
      if session[:player1] != "Human"
        human_turn = false
      end
    end
  else
    if session[:player1] != "Human"
      session[:player1].take_turn()
      if session[:player2] != "Human"
        human_turn = false
      end
    end
  end
  if session[:gameobj].check_winner()
    redirect '/end_game'
  end

  erb :next_move, locals: {game_inst: session[:gameobj], player_turn: human_turn, secret_mode: session[:secret]}
end

get '/end_game' do
  if !session[:gameobj]
    redirect '/'
  end

  cur_board = session[:gameobj]
  winner = cur_board.check_winner();
  if winner == "X"
    winner = "Pirates!"
  elsif winner == "O"
    winner = "Ninjas!"
  end
  log = session[:gameobj].game_log.gsub('~', '<br>')
  log = log.gsub('X', session[:player1].class.to_s)
  log = log.gsub('O', session[:player2].class.to_s)
  log = log.gsub('String', 'Human')
  p log
  erb :end_game, locals: {game_inst: session[:gameobj], victor: winner, secret_mode: session[:secret], game_log: log}
end