require_relative 'gameboard.rb'

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
                if @board.get_tile(1, 1) == @enemy_piece #They have center, must block one
                    @board.set_tile(next_move[0], next_move[1], @piece)
                    return true
                end
                #2 corner forks, force defend
                if @board.get_tile(beside(next_move[0]), next_move[1]) == 0 && opposite_tile(beside(next_move[0]), next_move[1]) == 0
                    @board.set_tile(beside(next_move[0]), next_move[1], @piece)
                    return true
                elsif @board.get_tile(next_move[0], beside(next_move[1])) == 0 && opposite_tile(next_move[0], beside(next_move[1])) == 0
                    @board.set_tile(next_move[0], beside(next_move[1]), @piece)
                    return true
                end
            else
                @board.set_tile(next_move[0], next_move[1], @piece)
                return true
            end
        end

        #Claim center
        if @board.get_center() == 0
            @board.set_center(@piece)
            return true
        end

        #Claim opposite corners
        next_move = claim_opposite_corner()
        if next_move
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
        while y < @board.size do 
            while x < @board.size do 
                if @board.get_tile(x, y) == @piece
                    found += 1
                elsif @board.get_tile(x, y) != 0
                    found -= 1
                end
                x += 1
            end
            if found == @board.size - 1
                x = 0
                while x < @board.size do 
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
        while x < @board.size do 
            while y < @board.size do
                if @board.get_tile(x, y) == @piece
                    found += 1
                elsif @board.get_tile(x, y) != 0
                    found -= 1
                end
                y += 1
            end
            if found == @board.size - 1
                y = 0
                while y < @board.size do
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
        while x < @board.size do
            if @board.get_tile(x, x) == @piece
                found += 1
            elsif @board.get_tile(x, x) != 0
                found -= 1
            end
            x += 1
        end

        if found == @board.size - 1
            x = 0
            while x < @board.size do
                @board.set_tile(x, x, piece)
                x += 1
            end
            return true
        end

        #BL > TR
        x = 0
        y = @board.size - 1
        found = 0
        while x < @board.size do
            if @board.get_tile(x, y) == @piece
                found += 1
            elsif @board.get_tile(x, y) != 0
                found -= 1
            end
            x += 1
            y -= 1
        end

        if found == @board.size - 1
            x = 0
            y = @board.size-1
            while x < @board.size do
                @board.set_tile(x, y, piece)
                x += 1
                y -= 1
            end
            return true
        end
        false
    end

    def block_win()
        found = 0
        x = 0
        y = 0
        #Across
        while y < @board.size do 
            while x < @board.size do 
                if @board.get_tile(x, y) == @enemy_piece
                    found += 1
                elsif @board.get_tile(x, y) == @piece
                    found -= 1
                end
                x += 1
            end
            if found == @board.size - 1
                x = 0
                while x < @board.size do 
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
        while x < @board.size do 
            while y < @board.size do
                if @board.get_tile(x, y) == @enemy_piece
                    found += 1
                elsif @board.get_tile(x, y) == @piece
                    found -= 1
                end
                y += 1
            end
            if found == @board.size - 1
                y = 0
                while y < @board.size do
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
        while x < @board.size do
            if @board.get_tile(x, x) == @enemy_piece
                found += 1
            elsif @board.get_tile(x, x) == @piece
                found -= 1
            end
            x += 1
        end
        if found == @board.size - 1
            x = 0
            while x < @board.size do
                if @board.get_tile(x, x) == 0
                    @board.set_tile(x, x, piece)
                end
                x += 1
            end
            return true
        end

        #BL > TR
        x = 0
        y = @board.size - 1
        found = 0
        while x < @board.size do
            if @board.get_tile(x, y) == @enemy_piece
                found += 1
            elsif @board.get_tile(x, y) == @piece
                found -= 1
            end
            x += 1
            y -= 1
        end
        if found == @board.size - 1
            x = 0
            y = @board.size-1
            while x < @board.size do
                if @board.get_tile(x, y) == 0
                    @board.set_tile(x, y, @piece)
                end
                x += 1
                y -= 1
            end
            return true
        end
        false
    end

    def claim_opposite_corner()
        if @board.get_tile(0, 0) == @enemy_piece && @board.get_tile(2, 2) == 0
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
        false
    end

    #Assumes board size 3x3
    def opp_pos(pos)
        if pos == 0
            pos = @board.size - 1
        elsif pos == @board.size - 1
            pos = 0
        end
        return pos
    end

    def beside(x)
        if x == 0
            return 1
        end
        return x-1
    end

    def opposite_tile(x, y)
        return @board.get_tile(opp_pos(x), opp_pos(y))
    end

    def fork_pattern(basex, basey)
        if @board.get_tile(basex, basey) == 0 && @board.get_tile(beside(basex), basey) == 0
            if opposite_tile(basex, basey) == 0
                return [basex, basey]
            end
            if opposite_tile(beside(basex), basey) == 0
                return [beside(basex), basey]
            end
            if @board.get_tile(opp_pos(basex), beside(basey)) == 0 && opposite_tile(basex, basey) == 0
                if  @board.get_tile(basex, beside(basey)) == 0
                    return [opp_pos(basex), beside(basey)]
                end
                if @board.get_tile(basex, basey) == 0
                    return [opp_pos(basex), opp_pos(basey)]
                end
            end
        end
        false
    end

    def block_side_pattern()
        if @board.get_tile(2, 1) == @enemy_piece && @board.get_tile(1, 2) == @enemy_piece
            if @board.get_tile(2, 2) == 0 && @board.get_tile(2, 0) == 0 && @board.get_tile(0, 2) == 0
                return [2, 2]
            end
        end
        if @board.get_tile(1, 0) == @enemy_piece && @board.get_tile(2, 1) == @enemy_piece
            if @board.get_tile(2, 0) == 0 && @board.get_tile(0, 0) == 0 && @board.get_tile(2, 2) == 0
                return [2, 0]
            end
        end
        if @board.get_tile(0, 1) == @enemy_piece && @board.get_tile(1, 0) == @enemy_piece
            if @board.get_tile(0, 0) == 0 && @board.get_tile(2, 0) == 0 && @board.get_tile(0, 2) == 0
                return [0, 0]
            end
        end
        if @board.get_tile(1, 2) == @enemy_piece && @board.get_tile(0, 1) == @enemy_piece
            if @board.get_tile(0, 2) == 0 && @board.get_tile(0, 0) == 0 && @board.get_tile(2, 2) == 0
                return [0, 2]
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

        if block_side_pattern() != false
            return block_side_pattern()
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