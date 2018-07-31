class GameBoard
    def initialize(width=3, height=3)
        @width = width
        @height = height
        @board = Array.new(width) {Array.new(height, 0)}
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
        false
    end

    attr_reader :width
    attr_reader :height
end