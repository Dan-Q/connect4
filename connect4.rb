#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'

require './lib/board.rb'

include Connect4

board = Board.new
player = 'X'
last_computer_move = nil

print `clear`
print "Choose difficulty level (0-6): "
difficulty = gets.strip.to_i

until board.valid_moves.empty? || !!board.winner
  if player == 'O'
    print `clear`
    puts "I'm thinking about my move..."
    puts board
    possible_next_moves = board.move_scores_for(piece: player, depth: difficulty)
    best_move = possible_next_moves.sort_by{|k,v| [v, rand()]}.last[0]
    board.play piece: player, col: best_move
    last_computer_move = "I played in column #{best_move}."
  else
    print `clear`
    puts last_computer_move
    puts board
    valid_move = false
    until valid_move
      c = gets.strip.to_i
      valid_move = board.play piece: player, col: c
    end
  end
  player = (player == 'X' ? 'O' : 'X')
end
print `clear`
if board.winner
  puts "'#{board.winner}' won!"
else
  puts "It's a draw!"
end
puts board
