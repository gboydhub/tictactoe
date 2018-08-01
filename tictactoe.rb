class GameBoard
    def initialize(size=3)
        @width = size
        @height = size
        @board = Array.new(size) {Array.new(size, 0)}
        @turns_taken = 0
    end

    def get_tile(x, y)
        if x >= 0 && x < @width && y >= 0 && y < @height
            return @board[x][y]
        end
        false 
    end

    def set_tile(x, y, marker)
        if x >= 0 && x < @width && y >= 0 && y < @height
            @board[x][y] = marker
            @turns_taken += 1
            return true
        end
        false
    end

    def check_winner()
        cross_counter = 0
        while cross_counter < @height do
            last_piece = @board[0][cross_counter]
            cur_x = 1
            while cur_x < @width do
                if @board[cur_x][cross_counter] != last_piece
                    break;
                end
                cur_x += 1
            end
            if cur_x == @width && last_piece != 0
                return last_piece
            end
            cross_counter += 1
        end

        down_counter = 0
        while down_counter < @width do
            last_piece = @board[down_counter][0]
            cur_y = 0
            while cur_y < @height do
                if @board[down_counter][cur_y] != last_piece
                    break;
                end
                cur_y += 1
            end
            if cur_y == @height && last_piece != 0
                return last_piece
            end
            down_counter += 1
        end

        #Top left to bottom right
        x_counter = 1
        y_counter = 1
        last_piece = @board[0][0]
        while x_counter < @width do
            if @board[x_counter][y_counter] != last_piece
                break;
            end
            x_counter += 1
            y_counter += 1
        end
        if x_counter == @width && last_piece != 0
            return last_piece
        end

        #Bottom left to top right
        x_counter = 1
        y_counter = @height - 2
        last_piece = @board[0][@height-1]
        while x_counter < @width do
            if @board[x_counter][y_counter] != last_piece
                break;
            end
            x_counter += 1
            y_counter -= 1
        end
        if x_counter == @width && last_piece != 0
            return last_piece
        end

        if @turns_taken >= @width * @height
            return "Draw"
        end

        false
    end

    def reset()
        @board = Array.new(@width) {Array.new(@height, 0)}
    end

    attr_reader :width
    attr_reader :height
    attr_reader :turns_taken
end

class BasePlayer
    def initialize
        @piece = 0
    end

    def set_board(game_board)
        @board = game_board
    end

    def take_turn()
        false
    end

    attr_accessor :piece
end

class RandomPlayer < BasePlayer
    def take_turn()
        valid_move_list = []
        check_x = 0
        check_y = 0
        while check_x < @board.width do
            while check_y < @board.height do
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

class SequentialPlayer < BasePlayer
    def take_turn()
        find_piece = [0, 0]
        f_x = 0
        f_y = 0
        while f_x < @board.width do
            while f_y < @board.height do
                if @board.get_tile(f_x, f_y) == @piece
                    if @board.get_tile(f_x - 1, f_y) == 0
                        find_piece = [f_x-1, f_y]
                    elsif @board.get_tile(f_x + 1, f_y) == 0
                        find_piece = [f_x+1, f_y]
                    elsif @board.get_tile(f_x, f_y - 1) == 0
                        find_piece = [f_x, f_y-1]
                    end
                end
                f_y += 1
            end
            f_x += 1
            f_y = 0
        end

        @board.set_tile(find_piece[0], find_piece[1], @piece)
        true
    end
end