require 'minitest/autorun'
require './lib/board'

include Connect4

describe 'Board' do
  before do
    @board = Board.new
  end

  it 'is empty to begin with' do
    7.times do |col|
      6.times do |row|
        assert_nil @board.cells[col][row]
      end
    end
  end

  it 'can be cloned' do
    @board.cells[4][5] = 'X'
    new_board = Board.new(state: @board)
    assert_equal 'X', new_board.cells[4][5]
    assert_nil new_board.cells[5][4]
  end

  it 'can have unusual dimensions' do
    assert_equal 7, @board.cols
    assert_equal 6, @board.rows
    new_board = Board::new(rows: 34, cols: 9)
    assert_equal 9, new_board.cols
    assert_equal 34, new_board.rows
  end

  it 'can have pieces played in columns that have space, and understands valid moves' do
    assert @board.play(piece: 'X', col: 1)
    assert @board.play(piece: 'O', col: 1)
    assert @board.play(piece: 'X', col: 1)
    assert @board.play(piece: 'O', col: 1)
    assert @board.play(piece: 'X', col: 1)
    assert_equal [1,2,3,4,5,6,7], @board.valid_moves
    assert @board.play(piece: 'O', col: 1)
    assert_equal [  2,3,4,5,6,7], @board.valid_moves
    assert !@board.play(piece: 'X', col: 1) # 7th piece would be off top of board
    assert @board.play(piece: 'X', col: 2)
    assert_equal 'XOXOXO', @board.cells[0].join # 1st column
    assert_equal 'X', @board.cells[1].join      # 2nd column
  end

  it 'cannot have pieces played off the edges of the board' do
    assert !@board.play(piece: 'X', col: 0)
    assert !@board.play(piece: 'X', col: 8)
  end

  it 'identifies "column" winners' do
    assert @board.play(piece: 'X', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 1)
    assert_equal 'X', @board.winner
    assert !@board.play(piece: 'O', col: 2) # somebody already won
  end

  it 'identifies "row" winners' do
    assert @board.play(piece: 'X', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 4)
    assert_equal 'X', @board.winner
    assert !@board.play(piece: 'O', col: 4) # somebody already won
  end

  it 'identifies / winners' do
    assert @board.play(piece: 'O', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 4)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 4)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 4)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 1)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 4)
    assert_equal 'O', @board.winner
    assert !@board.play(piece: 'X', col: 4) # somebody already won
  end

  it 'identifies \ winners' do
    assert @board.play(piece: 'O', col: 5)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 4)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 4)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 3)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal false, @board.winner
    assert @board.play(piece: 'X', col: 5)
    assert_equal false, @board.winner
    assert @board.play(piece: 'O', col: 2)
    assert_equal 'O', @board.winner
    assert !@board.play(piece: 'X', col: 4) # somebody already won
  end
end