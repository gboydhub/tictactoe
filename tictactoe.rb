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

    def take_turn(game_board)
        false
    end

    attr_accessor :piece
end

class RandomPlayer < BasePlayer
    def take_turn(game_board)
        true
    end
end