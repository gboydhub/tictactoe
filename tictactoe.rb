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

    attr_reader :width
    attr_reader :height
end