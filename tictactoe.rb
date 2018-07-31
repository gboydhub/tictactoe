class GameBoard
    def initialize(width=3, height=3)
        @width = width
        @height = height
    end

    attr_reader :width
    attr_reader :height
end