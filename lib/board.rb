module Connect4
  class Board
    attr_reader :rows, :cols, :cells

    # Instantiates a new board. Can either be passed an existing board as a state:,
    # in which case this board will be deep-cloned, or rows: and cols: numbers (which
    # will default to 6 and 7, respectively) for a blank board.
    def initialize(rows: 6, cols: 7, state: nil)
      if state.is_a?(Board)  # a board has been provided; let's deep-clone it
        @rows, @cols = state.rows, state.cols
        @cells = empty_cells(@rows, @cols)
        @cols.times do |c|
          @rows.times do |r|
            @cells[c][r] = state.cells[c][r] if state.cells[c][r]
          end
        end
      else                   # create a brand new empty board
        @rows, @cols = rows, cols
        @cells = empty_cells(@rows, @cols)
      end
    end

    # Plays the specified piece into the specified column (1-indexed)
    # Returns true if successful, false otherwise
    def play(piece:, col:)
      return false if col < 1 || col > @cols          # out of bounds
      return false if @cells[col - 1].length >= @rows # column full
      return false if !!winner                        # somebody already won
      @cells[col-1].push piece
      true
    end

    # Returns the winner, or false if nobody won
    def winner
      @cols.times do |c|
        @rows.times do |r|
          if (piece = @cells[c][r]) != nil
            return piece if (r <= (@rows - 4)) && [piece, @cells[c][r+1], @cells[c][r+2], @cells[c][r+3]].uniq.length == 1 # col-of-4
            return piece if (c <= (@cols - 4)) && [piece, @cells[c+1][r], @cells[c+2][r], @cells[c+3][r]].uniq.length == 1 # row-of-4
            return piece if (r <= (@rows - 4)) && (c <= (@cols - 4)) && [piece, @cells[c+1][r+1], @cells[c+2][r+2], @cells[c+3][r+3]].uniq.length == 1 # /-of-4
            return piece if (r >= 3) && (c <= (@cols - 4)) && [piece, @cells[c+1][r-1], @cells[c+2][r-2], @cells[c+3][r-3]].uniq.length == 1 # \-of-4
          end
        end
      end
      false
    end

    # Returns an array of valid moves (in 1-indexed format)
    def valid_moves
      (0...@cols).to_a.reject{|c| @cells[c].length == @rows}.map{|c| c+1}
    end

    # Given a piece to play as and a depth to search to, returns a hash of possible moves and the relative scores for each
    def move_scores_for(piece:, depth: 6)
      # For each prospective move:
      valid_moves.reduce({}) do |scores, col|
        # Clone this board and make the move
        prospective_board = Board.new(state: self)
        prospective_board.play(piece: piece, col: col)
        # Score the move
        if !!prospective_board.winner
          # If this move would result in me winning, it's great. [1]
          # If it would result in my opponent winning (not possible in Connect4, but still), it's awful. [-1]
          scores[col] = (prospective_board.winner == piece) ? 1 : -1
        elsif depth > 1
          # Otherwise, if I've not depth-searched very far, the score is the average of the inverse scores of all SUBSEQUENT moves
          # Average, because we only care about the permutations (this could be changed to affect strategy).
          # Inverse, because this is the OTHER player's move!
          other_players_piece = (piece == 'X' ? 'O' : 'X')
          next_move_scores = prospective_board.move_scores_for(piece: other_players_piece, depth: depth - 1).values
          average = next_move_scores.reduce(:+).to_f / next_move_scores.length
          scores[col] = -1 * average
        else
          # Failing that, we assume it's a neutral move (we don't have enough foresight to say otherwise)
          scores[col] = 0
        end
        scores
      end
    end

    # Prints a string output of the board
    def to_s
      result  = "+#{'---+'*@cols}\n"
      result << "|#{@cols.times.map{|c|"#{(c+1).to_s.center(3)}|"}.join}\n"
      result << "+#{'---+'*@cols}\n"
      @rows.times do |r|
        result << "|#{@cols.times.map{|c|"#{@cells[c][@rows-r-1].to_s.center(3)}|"}.join}\n"
        result << "+#{'---+'*@cols}\n"
      end
      result
    end

    private

    def empty_cells(rows, cols)
      cols.times.map { [] }  
    end
  end
end
