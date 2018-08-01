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
        test_board = GameBoard.new(3)
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

    def test_game_board_check_winner_extended
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(1, 0, :x))
        assert_equal(true, test_board.set_tile(1, 1, :x))
        assert_equal(true, test_board.set_tile(1, 2, :x))
        assert_equal(:x, test_board.check_winner())
        assert_equal(true, test_board.set_tile(1, 0, :o))
        assert_equal(true, test_board.set_tile(1, 2, :o))

        assert_equal(true, test_board.set_tile(0, 1, :x))
        assert_equal(true, test_board.set_tile(1, 1, :x))
        assert_equal(true, test_board.set_tile(2, 1, :x))
        assert_equal(:x, test_board.check_winner())

        assert_equal(true, test_board.set_tile(0, 0, :o))
        assert_equal(true, test_board.set_tile(2, 2, :o))
        assert_equal(true, test_board.set_tile(1, 1, :o))
        assert_equal(:o, test_board.check_winner())
    end

    def test_game_board_reset
        test_board = GameBoard.new
        assert_equal(true, test_board.set_tile(1, 0, :x))
        assert_equal(true, test_board.set_tile(1, 1, :x))
        assert_equal(true, test_board.set_tile(1, 2, :x))

        test_board.reset()
        assert_equal(false, test_board.check_winner())
    end

    def test_player_base
        plr = BasePlayer.new
    end

    def test_player_base_taketurn
        plr = BasePlayer.new
        board = GameBoard.new
        plr.set_board(board)
        assert_equal(false, plr.take_turn())
    end

    def test_random_player_exist
        plr = RandomPlayer.new
    end

    def test_random_player_extends_base
        plr = RandomPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.take_turn()
    end

    def test_random_player_takes_turn
        plr = RandomPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        assert_equal(true, plr.take_turn())
    end

    def test_base_player_sets_piece
        plr = BasePlayer.new
        plr.piece = :x
        assert_equal(:x, plr.piece)
    end

    def test_random_player_sets_piece
        plr = RandomPlayer.new
        plr.piece = :x
        assert_equal(:x, plr.piece)
    end

    def test_game_board_shows_turns_taken
        brd = GameBoard.new
        assert_equal(0, brd.turns_taken)
        brd.set_tile(0, 0, :x)
        assert_equal(1, brd.turns_taken)
    end

    def test_random_player_takes_turn
        plr = RandomPlayer.new
        brd = GameBoard.new
        plr.set_board(brd)
        plr.piece = :x
        assert_equal(true, plr.take_turn())
        assert_equal(1, brd.turns_taken)
    end

    def test_random_player_fills_board
        plr = RandomPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :x

        counter = 0
        while counter < (board.width * board.height) do
            assert_equal(true, plr.take_turn())
            counter += 1
        end

        counter = 0
        while counter < (board.width * board.height) do
            assert_equal(:x, board.get_tile(counter % 3, (counter / 3).floor))
            counter += 1
        end

        assert_equal(false, plr.take_turn())
    end

    def test_seq_player_exist
        plr = SequentialPlayer.new
        plr.piece = "X"
        assert_equal("X", plr.piece)
    end

    def test_seq_player_picks_topleft
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        assert_equal(true, plr.take_turn())
        assert_equal(:X, board.get_tile(0, 0))
    end

    def test_seq_player_picks_left
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        board.set_tile(1, 1, :X)
        plr.take_turn()
        assert_equal(:X, board.get_tile(0, 1))
    end

    def test_seq_player_picks_right
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        board.set_tile(0, 1, :X)
        plr.take_turn()
        assert_equal(:X, board.get_tile(1, 1))
    end

    def test_seq_player_wins_in_2
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        board.set_tile(1, 1, :X)
        plr.take_turn()
        plr.take_turn()
        assert_equal(:X, board.check_winner())
    end

    def test_seq_player_picks_top
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        board.set_tile(0, 2, :O)
        board.set_tile(1, 2, :X)
        board.set_tile(2, 2, :O)
        plr.take_turn()
        assert_equal(:X, board.get_tile(1, 1))
    end

    def test_seq_player_picks_bottom
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        board.set_tile(0, 0, :O)
        board.set_tile(1, 0, :X)
        board.set_tile(2, 0, :O)
        plr.take_turn()
        assert_equal(:X, board.get_tile(1, 1))
    end

    def test_seq_player_picks_first_empty
        plr = SequentialPlayer.new
        board = GameBoard.new
        plr.set_board(board)
        plr.piece = :X

        board.set_tile(0, 0, :O)
        plr.take_turn()
        assert_equal(:X, board.get_tile(1, 0))
        
        board.set_tile(1, 0, :O)
        board.set_tile(2, 0, :O)
        plr.take_turn()
        assert_equal(:X, board.get_tile(0, 1))
    end
end