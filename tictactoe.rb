class GameBoard
    def initialize(size=3)
        @width = size
        @height = size
        @board = Array.new(size) {Array.new(size, 0)}
        @turns_taken = 0
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
            @turns_taken += 1
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

        #Top left to bottom right
        x_counter = 1
        y_counter = 1
        last_piece = @board[0][0]
        while x_counter < @width do
            if @board[x_counter][y_counter] != last_piece
                break;
            end
            x_counter += 1
            y_counter += 1
        end
        if x_counter == @width && last_piece != 0
            return last_piece
        end

        #Bottom left to top right
        x_counter = 1
        y_counter = @height - 2
        last_piece = @board[0][@height-1]
        while x_counter < @width do
            if @board[x_counter][y_counter] != last_piece
                break;
            end
            x_counter += 1
            y_counter -= 1
        end
        if x_counter == @width && last_piece != 0
            return last_piece
        end

        if @turns_taken >= @width * @height
            return "Draw"
        end

        false
    end

    def reset()
        x = 0
        y = 0
        while x < @width do 
            while y < @height do
                @board[x][y] = 0
                y += 1
            end
            y = 0
            x += 1
        end
    end

    attr_reader :width
    attr_reader :height
    attr_reader :turns_taken

    attr_reader :board
end

class BasePlayer
    def initialize
        @piece = 0
    end

    def set_board(game_board)
        @board = game_board
    end

    def take_turn()
        false
    end

    attr_accessor :piece
end

class RandomPlayer < BasePlayer
    def take_turn()
        valid_move_list = []
        check_x = 0
        check_y = 0
        while check_x < @board.width do
            while check_y < @board.height do
                if @board.get_tile(check_x, check_y) == 0
                    valid_move_list << [check_x, check_y]
                end
                check_y += 1
            end
            check_y = 0
            check_x += 1
        end

        if valid_move_list.length > 0
            chosen_move = valid_move_list[Random.rand(valid_move_list.length)]
            @board.set_tile(chosen_move[0], chosen_move[1], @piece)
            return true
        end
        false
    end
end

class SequentialPlayer < BasePlayer
    def take_turn()
        find_piece = []
        f_x = 0
        f_y = 0
        while f_x < @board.width do
            while f_y < @board.height do
                if @board.get_tile(f_x, f_y) == @piece
                    if @board.get_tile(f_x - 1, f_y) == 0
                        find_piece = [f_x-1, f_y]
                    elsif @board.get_tile(f_x + 1, f_y) == 0
                        find_piece = [f_x+1, f_y]
                    elsif @board.get_tile(f_x, f_y - 1) == 0
                        find_piece = [f_x, f_y-1]
                    elsif @board.get_tile(f_x, f_y + 1) == 0
                        find_piece = [f_x, f_y+1]
                    end
                end
                f_y += 1
            end
            f_x += 1
            f_y = 0
        end

        if find_piece == []
            f_x = 0
            f_y = 0
            while f_y < @board.height do
                while f_x < @board.width do
                    if @board.get_tile(f_x, f_y) == 0
                        find_piece = [f_x, f_y]
                        break
                    end
                    f_x += 1
                end
                if find_piece != []
                    break
                end
                f_y += 1
                f_x = 0
            end
        end

        if find_piece == []
            return false
        end
        @board.set_tile(find_piece[0], find_piece[1], @piece)
        true
    end
end

class UnbeatablePlayer < BasePlayer
    def take_turn()

    end

    def check_win()
    end
end

# Win: If the player has two in a row, they can place a third to get three in a row.
# Block: If the opponent has two in a row, the player must play the third themselves to block the opponent.
# Fork: Create an opportunity where the player has two threats to win (two non-blocked lines of 2).
# Blocking an opponent's fork: If there is only one possible fork for the opponent, the player should block it. Otherwise, the player should block any forks in any way that simultaneously allows them to create two in a row. Otherwise, the player should create a two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork. For example, if "X" has two opposite corners and "O" has the center, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)

# Center: A player marks the center. (If it is the first move of the game, playing on a corner gives the second player more opportunities to make a mistake and may therefore be the better choice; however, it makes no difference between perfect players.)

# Opposite corner: If the opponent is in the corner, the player plays the opposite corner.
# Empty corner: The player plays in a corner square.
# Empty side: The player plays in a middle square on any of the 4 sides.