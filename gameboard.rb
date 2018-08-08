class GameBoard
    def initialize(size=3)
        @size = size
        @board = Array.new(size) {Array.new(size, 0)}
        @turns_taken = 0
    end

    def get_tile(x, y)
        if x >= 0 && x < @size && y >= 0 && y < @size
            return @board[x][y]
        end
        false 
    end

    def set_tile(x, y, marker)
        if x >= 0 && x < @size && y >= 0 && y < @size
            @board[x][y] = marker
            @turns_taken += 1
            return true
        end
        false
    end

    def check_winner()
        cross_counter = 0
        while cross_counter < @size do
            last_piece = @board[0][cross_counter]
            cur_x = 1
            while cur_x < @size do
                if @board[cur_x][cross_counter] != last_piece
                    break;
                end
                cur_x += 1
            end
            if cur_x == @size && last_piece != 0
                return last_piece
            end
            cross_counter += 1
        end

        down_counter = 0
        while down_counter < @size do
            last_piece = @board[down_counter][0]
            cur_y = 0
            while cur_y < @size do
                if @board[down_counter][cur_y] != last_piece
                    break;
                end
                cur_y += 1
            end
            if cur_y == @size && last_piece != 0
                return last_piece
            end
            down_counter += 1
        end

        #Top left to bottom right
        x_counter = 1
        y_counter = 1
        last_piece = @board[0][0]
        while x_counter < @size do
            if @board[x_counter][y_counter] != last_piece
                break;
            end
            x_counter += 1
            y_counter += 1
        end
        if x_counter == @size && last_piece != 0
            return last_piece
        end

        #Bottom left to top right
        x_counter = 1
        y_counter = @size - 2
        last_piece = @board[0][@size-1]
        while x_counter < @size do
            if @board[x_counter][y_counter] != last_piece
                break;
            end
            x_counter += 1
            y_counter -= 1
        end
        if x_counter == @size && last_piece != 0
            return last_piece
        end

        if @turns_taken >= @size * @size
            return "Draw"
        end

        false
    end

    def reset()
        x = 0
        y = 0
        while x < @size do 
            while y < @size do
                @board[x][y] = 0
                y += 1
            end
            y = 0
            x += 1
        end
        turns_taken = 0
    end

    attr_reader :size
    attr_reader :size
    attr_reader :turns_taken
end