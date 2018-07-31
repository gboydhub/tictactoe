class GameBoard
    def initialize(width=3, height=3)
        @width = width
        @height = height
    end

    def get_tile(x, y)
        0
    end

    attr_reader :width
    attr_reader :height
end