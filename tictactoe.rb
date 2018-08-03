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
        turns_taken = 0
    end

    attr_reader :width
    attr_reader :height
    attr_reader :turns_taken
end

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
        #Make winning move
        next_move = check_win()
        if next_move
            return true
        end
        #Block losing move
        next_move = block_win()
        if next_move
            return true
        end
        #Try and create fork
        next_move = find_potential_fork(@piece)
        if next_move
            @board.set_tile(next_move[0], next_move[1], @piece)
            return true
        end
        #Check potential enemy forks
        next_move = find_potential_fork(@enemy_piece)
        if next_move
            if opposite_tile(next_move[0], next_move[1]) == 0
                #2 forks, force defend
                if @board.get_tile(beside_x(next_move[0]), next_move[1]) == 0 && opposite_tile(beside_x(next_move[0]), next_move[1]) == 0
                    @board.set_tile(beside_x(next_move[0]), next_move[1], @piece)
                    return true
                elsif @board.get_tile(next_move[0], beside_y(next_move[1])) == 0 && opposite_tile(next_move[0], beside_y(next_move[1])) == 0
                    @board.set_tile(next_move[0], beside_y(next_move[1]), @piece)
                    return true
                end
            else
                @board.set_tile(next_move[0], next_move[1], @piece)
                return true
            end
        end

        #Claim center
        if @board.get_tile(1, 1) == 0
            @board.set_tile(1, 1, @piece)
            return true
        end

        #Claim opposite corners
        if @board.get_tile(0, 0) == @enemy_piece && opposite_tile(0, 0) == 0
            @board.set_tile(2, 2, @piece)
            return true
        end
        if @board.get_tile(2, 2) == @enemy_piece && @board.get_tile(0, 0) == 0
            @board.set_tile(0, 0, @piece)
            return true
        end
        if @board.get_tile(2, 0) == @enemy_piece && @board.get_tile(0, 2) == 0
            @board.set_tile(0, 2, @piece)
            return true
        end
        if @board.get_tile(0, 2) == @enemy_piece && @board.get_tile(2, 0) == 0
            @board.set_tile(2, 0, @piece)
            return true
        end
        #Claim corner
        if @board.get_tile(0, 0) == 0
            @board.set_tile(0, 0, @piece)
            return true
        end
        if @board.get_tile(0, 2) == 0
            @board.set_tile(0, 2, @piece)
            return true
        end
        if @board.get_tile(2, 0) == 0
            @board.set_tile(2, 0, @piece)
            return true
        end
        if @board.get_tile(2, 2) == 0
            @board.set_tile(2, 2, @piece)
            return true
        end

        #Claim side
        if @board.get_tile(1, 0) == 0
            @board.set_tile(1, 0, @piece)
            return true
        end
        if @board.get_tile(1, 2) == 0
            @board.set_tile(1, 2, @piece)
            return true
        end
        if @board.get_tile(0, 1) == 0
            @board.set_tile(0, 1, @piece)
            return true
        end
        if @board.get_tile(2, 1) == 0
            @board.set_tile(2, 1, @piece)
            return true
        end
        false
    end

    def check_win()
        found = 0
        x = 0
        y = 0
        #Across
        while y < @board.height do 
            while x < @board.width do 
                if @board.get_tile(x, y) == @piece
                    found += 1
                elsif @board.get_tile(x, y) != 0
                    found -= 1
                end
                x += 1
            end
            if found == @board.width - 1
                x = 0
                while x < @board.width do 
                    @board.set_tile(x, y, @piece)
                    x += 1
                end
                return true
            end
            x = 0
            found = 0
            y += 1
        end

        #Down
        x = 0
        y = 0
        found = 0
        while x < @board.width do 
            while y < @board.height do
                if @board.get_tile(x, y) == @piece
                    found += 1
                elsif @board.get_tile(x, y) != 0
                    found -= 1
                end
                y += 1
            end
            if found == @board.height - 1
                y = 0
                while y < @board.height do
                    @board.set_tile(x, y, @piece)
                    y += 1
                end
                return true
            end
            y = 0
            found = 0
            x += 1
        end

        #TL > BR
        x = 0
        found = 0
        while x < @board.width do
            if @board.get_tile(x, x) == @piece
                found += 1
            elsif @board.get_tile(x, x) != 0
                found -= 1
            end

            if found == @board.width - 1
                x = 0
                while x < @board.width do
                    @board.set_tile(x, x, piece)
                    x += 1
                end
                return true
            end
            x += 1
        end

        #BL > TR
        x = 0
        y = @board.height - 1
        found = 0
        while x < @board.width do
            if @board.get_tile(x, y) == @piece
                found += 1
            elsif @board.get_tile(x, x) != 0
                found -= 1
            end

            if found == @board.width - 1
                x = 0
                y = @board.height-1
                while x < @board.width do
                    @board.set_tile(x, y, piece)
                    x += 1
                    y -= 1
                end
                return true
            end
            x += 1
            y -= 1
        end
        false
    end

    def block_win()
        found = 0
        x = 0
        y = 0
        #Across
        while y < @board.height do 
            while x < @board.width do 
                if @board.get_tile(x, y) == @piece
                    found -= 1
                elsif @board.get_tile(x, y) != 0
                    found += 1
                end
                x += 1
            end
            if found == @board.width - 1
                x = 0
                while x < @board.width do 
                    if @board.get_tile(x, y) == 0
                        @board.set_tile(x, y, @piece)
                    end
                    x += 1
                end
                return true
            end
            x = 0
            found = 0
            y += 1
        end

        #Down
        x = 0
        y = 0
        found = 0
        while x < @board.width do 
            while y < @board.height do
                if @board.get_tile(x, y) == @piece
                    found -= 1
                elsif @board.get_tile(x, y) != 0
                    found += 1
                end
                y += 1
            end
            if found == @board.height - 1
                y = 0
                while y < @board.height do
                    if @board.get_tile(x, y) == 0
                        @board.set_tile(x, y, @piece)
                    end
                    y += 1
                end
                return true
            end
            y = 0
            found = 0
            x += 1
        end

        #TL > BR
        x = 0
        found = 0
        while x < @board.width do
            if @board.get_tile(x, x) == @piece
                found -= 1
            elsif @board.get_tile(x, x) != 0
                found += 1
            end

            if found == @board.width - 1
                x = 0
                while x < @board.width do
                    if @board.get_tile(x, x) == 0
                        @board.set_tile(x, x, piece)
                    end
                    x += 1
                end
                return true
            end
            x += 1
        end

        #BL > TR
        x = 0
        y = @board.height - 1
        found = 0
        while x < @board.width do
            if @board.get_tile(x, y) == @piece
                found -= 1
            elsif @board.get_tile(x, y) != 0
                found += 1
            end

            if found == @board.width - 1
                x = 0
                y = @board.height-1
                while x < @board.width do
                    if @board.get_tile(x, y) == 0
                        @board.set_tile(x, y, @piece)
                    end
                    x += 1
                    y -= 1
                end
                return true
            end
            x += 1
            y -= 1
        end
        false
    end

    #Assumes board size 3x3
    def opp_pos(pos)
        if pos == 0
            pos = @board.width - 1
        elsif pos == @board.width - 1
            pos = 0
        end
        return pos
    end

    def beside_x(x)
        if x == 0
            return 1
        end
        return x-1
    end

    def beside_y(y)
        if y==0
            return 1
        end
        return y-1
    end

    def opposite_tile(x, y)
        return @board.get_tile(opp_pos(x), opp_pos(y))
    end

    def fork_pattern(basex, basey)
        if @board.get_tile(basex, basey) == 0 && @board.get_tile(beside_x(basex), basey) == 0
            if opposite_tile(basex, basey) == 0
                return [basex, basey]
            end
            if opposite_tile(beside_x(basex), basey) == 0
                return [beside_x(basex), basey]
            end
            if @board.get_tile(opp_pos(basex), beside_y(basey)) == 0 && opposite_tile(basex, basey) == 0
                if  @board.get_tile(basex, beside_y(basey)) == 0
                    return [opp_pos(basex), beside_y(basey)]
                end
                if @board.get_tile(basex, basey) == 0
                    return [opp_pos(basex), opp_pos(basey)]
                end
            end
        end
        false
    end

    def find_potential_fork(symbol)
        if @board.get_tile(0, 0) == symbol && @board.get_tile(2, 2) == symbol
            #TL/BR
            if @board.get_tile(2, 0) == 0 && @board.get_tile(1, 0) == 0 && @board.get_tile(2, 1) == 0
                return [2, 0] #Mark TR
            end
            if @board.get_tile(0, 2) == 0 && @board.get_tile(0, 1) == 0 && @board.get_tile(1, 2) == 0
                return [0, 2] #Mark BL
            end
        end

        if @board.get_tile(2, 0) == symbol && @board.get_tile(0, 2) == symbol
            #TR/BL
            if @board.get_tile(0, 0) == 0 && @board.get_tile(0, 1) == 0 && @board.get_tile(1, 0) == 0
                return [0, 0] #Mark TL
            end
            if @board.get_tile(2, 2) == 0 && @board.get_tile(1, 2) == 0 && @board.get_tile(2, 1) == 0
                return [2, 2] #Mark BR
            end
        end

        if @board.get_tile(1, 1) == symbol
            #Check around center
            if @board.get_tile(0, 0) == symbol || opposite_tile(0, 0) == symbol
                found_pattern = fork_pattern(2, 0)
                if found_pattern != false
                    return found_pattern
                end
                found_pattern = fork_pattern(0, 2)
                if found_pattern != false
                    return found_pattern
                end
            end
            if @board.get_tile(2, 0) == symbol || opposite_tile(2, 0) == symbol
                found_pattern = fork_pattern(0, 0)
                if found_pattern != false
                    return found_pattern
                end
                found_pattern = fork_pattern(2, 2)
                if found_pattern != false
                    return found_pattern
                end
            end
        end

        false
    end
end

# ~Win: If the player has two in a row, they can place a third to get three in a row.
# ~Block: If the opponent has two in a row, the player must play the third themselves to block the opponent.
# ~Fork: Create an opportunity where the player has two threats to win (two non-blocked lines of 2).
# ~?Blocking an opponent's fork: If there is only one possible fork for the opponent, the player should block it. Otherwise, the player should block any forks in any way that simultaneously allows them to create two in a row. Otherwise, the player should create a two in a row to force the opponent into defending, as long as it doesn't result in them creating a fork. For example, if "X" has two opposite corners and "O" has the center, "O" must not play a corner in order to win. (Playing a corner in this scenario creates a fork for "X" to win.)

# Center: A player marks the center. (If it is the first move of the game, playing on a corner gives the second player more opportunities to make a mistake and may therefore be the better choice; however, it makes no difference between perfect players.)

# Opposite corner: If the opponent is in the corner, the player plays the opposite corner.
# Empty corner: The player plays in a corner square.
# Empty side: The player plays in a middle square on any of the 4 sides.