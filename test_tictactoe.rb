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

    def test_game_board_set_and_get
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 0, 1))
        assert_equal(1, test_board.get_tile(0, 0))

        assert_equal(true, test_board.set_tile(0, 2, 2))
        assert_equal(2, test_board.get_tile(0, 2))

        assert_equal(false, test_board.set_tile(4, 0, 1))
        assert_equal(false, test_board.get_tile(4, 0))
    end

    def test_game_board_with_symbols
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 0, :x))
        assert_equal(:x, test_board.get_tile(0, 0))
    end

    def test_game_board_check_winner_across
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 0, :x))
        assert_equal(true, test_board.set_tile(1, 0, :x))
        assert_equal(true, test_board.set_tile(2, 0, :x))
        assert_equal(:x, test_board.check_winner())
        
        assert_equal(true, test_board.set_tile(2, 0, :o))
        assert_equal(false, test_board.check_winner())
    end

    def test_game_board_check_winner_down
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 0, :x))
        assert_equal(true, test_board.set_tile(0, 1, :x))
        assert_equal(true, test_board.set_tile(0, 2, :x))
        assert_equal(:x, test_board.check_winner())
        
        assert_equal(true, test_board.set_tile(0, 1, :o))
        assert_equal(false, test_board.check_winner())
    end

    def test_game_board_check_winner_diag
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 0, :x))
        assert_equal(true, test_board.set_tile(1, 1, :x))
        assert_equal(true, test_board.set_tile(2, 2, :x))
        assert_equal(:x, test_board.check_winner())
        
        assert_equal(true, test_board.set_tile(1, 1, :o))
        assert_equal(false, test_board.check_winner())
    end

    def test_game_board_check_winner_diag_bottom
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(0, 2, :x))
        assert_equal(true, test_board.set_tile(1, 1, :x))
        assert_equal(true, test_board.set_tile(2, 0, :x))
        assert_equal(:x, test_board.check_winner())
        
        assert_equal(true, test_board.set_tile(1, 1, :o))
        assert_equal(false, test_board.check_winner())
    end
end