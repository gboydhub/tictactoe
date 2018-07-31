require "minitest/autorun"
require_relative "tictactoe.rb"

class TestTicTacToe < Minitest::Test
    def test_assert_that_1_equals_1
        assert_equal(1, 1)
    end

    def test_create_game_board
        test_board = GameBoard.new
        assert_equal(GameBoard, test_board.class)
    end

    def test_create_game_board_size
        test_board = GameBoard.new(3, 3)
        assert_equal(GameBoard, test_board.class)
    end
end