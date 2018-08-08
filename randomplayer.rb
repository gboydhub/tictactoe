require_relative 'baseplayer.rb'

class RandomPlayer < BasePlayer
    def take_turn()
        valid_move_list = []
        check_x = 0
        check_y = 0
        while check_x < @board.size do
            while check_y < @board.size do
                if @board.get_tile(check_x, check_y) == 0
                    valid_move_list << [check_x, check_y]
                end
                check_y += 1
            end
            check_y = 0
            check_x += 1
        end

        if valid_move_list.length > 0
            chosen_move = valid_move_list[Random.rand(valid_move_list.length)]
            @board.set_tile(chosen_move[0], chosen_move[1], @piece)
            return true
        end
        false
    end
end