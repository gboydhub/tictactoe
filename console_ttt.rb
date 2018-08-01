require_relative 'tictactoe.rb'

def display_board(board)
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
            print draw_piece + sep
        end
    end
end

board = GameBoard.new
random_player = RandomPlayer.new
random_playerB = RandomPlayer.new
random_player.set_board(board)
random_player.piece = :X
random_playerB.set_board(board)
random_playerB.piece = :O

while !board.check_winner() do
    system 'cls'
    if board.turns_taken % 2 == 0
        random_player.take_turn()
    else
        random_playerB.take_turn()
    end
    display_board(board)
end

puts "#{board.check_winner()} wins the game!"