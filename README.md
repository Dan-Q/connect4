# Connect4
Very basic implementation of a brute-force Connect 4 playing computer game, as a fun lunch-break project, in Ruby, with mostly-complete unit tests.

To play in terminal:
./connect4.rb

Choose a difficulty. This is the brute force search depth. 0 will only make a move if it makes the computer win, otherwise plays randomly. 1 will make a move only to make itself win or prevent human from winning, otherwise random. 2 will think one move ahead for itself. 3 will think one move ahead for itself and opponent. And so on: by the time the difficulty is turned up to 6 it's pretty-much impossible to beat! Good luck!
