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

    def test_game_board_get_size
        test_board = GameBoard.new
        assert_equal(3, test_board.width)
        assert_equal(3, test_board.height)
    end

    def test_game_board_get_tile
        test_board = GameBoard.new
        assert_equal(0, test_board.get_tile(0, 0))
    end

    def test_game_board_set_tile
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 0, 1))
    end
end