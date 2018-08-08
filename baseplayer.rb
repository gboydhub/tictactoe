class BasePlayer
    def initialize
        @piece = 0
        @enemy_piece = 0
    end

    def set_board(game_board)
        @board = game_board
    end

    def take_turn()
        false
    end

    attr_accessor :piece
    attr_accessor :enemy_piece
end