require_relative 'baseplayer.rb'

class SequentialPlayer < BasePlayer
    def take_turn()
        find_piece = []
        f_x = 0
        f_y = 0
        while f_x < @board.size do
            while f_y < @board.size do
                if @board.get_tile(f_x, f_y) == @piece
                    if @board.get_tile(f_x - 1, f_y) == 0
                        find_piece = [f_x-1, f_y]
                    elsif @board.get_tile(f_x + 1, f_y) == 0
                        find_piece = [f_x+1, f_y]
                    elsif @board.get_tile(f_x, f_y - 1) == 0
                        find_piece = [f_x, f_y-1]
                    elsif @board.get_tile(f_x, f_y + 1) == 0
                        find_piece = [f_x, f_y+1]
                    end
                end
                f_y += 1
            end
            f_x += 1
            f_y = 0
        end

        if find_piece == []
            f_x = 0
            f_y = 0
            while f_y < @board.size do
                while f_x < @board.size do
                    if @board.get_tile(f_x, f_y) == 0
                        find_piece = [f_x, f_y]
                        break
                    end
                    f_x += 1
                end
                if find_piece != []
                    break
                end
                f_y += 1
                f_x = 0
            end
        end

        if find_piece == []
            return false
        end
        @board.set_tile(find_piece[0], find_piece[1], @piece)
        true
    end
end