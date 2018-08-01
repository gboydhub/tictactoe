require_relative 'tictactoe.rb'

avail_pieces = ['O', 'X']

def display_board(board)
    puts " |1 2 3"
    puts "-------"
    for y in 0..board.height-1
        for x in 0..board.width-1
            draw_piece = " "
            sep = ","
            if board.get_tile(x, y) != 0
                draw_piece = board.get_tile(x, y).to_s
            end
            if x == board.width-1
                sep = "\n"
            end
            if x == 0
                print "#{('A'.ord+y).chr}|"
            end
            print draw_piece + sep
        end
    end
end

def ask_player_move(board, piece)
    pick_move = ""
    valid_move = false
    x_loc = 0
    y_loc = 0
    while valid_move == false do
        print "\n#{piece}, it is your turn.\nChoose a location [ex B3]:"
        move_picked = gets.chomp
        if move_picked.length == 2
            y_loc = move_picked[0]
            x_loc = move_picked[1]

            if x_loc.to_i.to_s == x_loc #X loc is a number
                if x_loc.to_i <= board.width #X is valid
                    x_loc = x_loc.to_i - 1
                    y_loc = (y_loc.ord - "A".ord)
                    if y_loc < board.height #Y is valid
                        if board.get_tile(x_loc, y_loc) == 0 && board.set_tile(x_loc, y_loc, piece) #Move is valid on board
                            valid_move = true
                        else
                            puts "That is an invalid move, try another."
                        end
                    end
                end
            end
        end
    end
end


num_humans = -1
while num_humans < 0 || num_humans > 2
    print "How many human players [0-2]: "
    num_humans = gets.chomp.to_i
end

choose_piece = "-"
player1_turn = 0
if num_humans > 0
    while !avail_pieces.include?(choose_piece) do
        print "Player 1, do you want to be O or X (blank for random): "
        choose_piece = gets.chomp.upcase
        if choose_piece == ""
            choose_piece = avail_pieces[Random.rand(avail_pieces.length)]
        end
    end
    avail_pieces.delete_at(avail_pieces.index(choose_piece))
    player_piece = [choose_piece]
    if num_humans == 2
        player_piece << avail_pieces[0]
    end

    if choose_piece == "X"
        player1_turn = 1
    end
end

#Create required AI's
ai_list = []
ai_gen_counter = 2
while ai_gen_counter > num_humans
    ai_list << RandomPlayer.new
    ai_gen_counter -= 1
end

#Setup board and AI
board = GameBoard.new
ai_list.each_with_index do |val, ind|
    ai_list[ind].set_board(board)
    ai_list[ind].piece = avail_pieces[ind]
end

#Game loop
while !board.check_winner() do
    system 'cls'
    display_board(board)
    if num_humans == 0
        ai_list[board.turns_taken % 2].take_turn()
    elsif num_humans == 1
        if board.turns_taken % 2 == player1_turn
            ask_player_move(board, player_piece[0])
        else
            ai_list[0].take_turn()
        end
    else
        if board.turns_taken % 2 == 0
            ask_player_move(board, :O)
        else
            ask_player_move(board, :X)
        end
    end
end

system 'cls'
display_board(board)
#Display winner
winner = board.check_winner()
if winner == "Draw"
    puts "\nThe game is a draw!"
else
    if num_humans == 1 && player_piece[0] == winner
            winner = "Player 1"
    end
    if num_humans == 2
        if player_piece[0] == winner
            winner = "Player 1"
        else
            winner = "Player 2"
        end
    end
    puts "\n#{winner} wins the game!"
end