# Game of Life Simulation - Using a random board to start with and recycling when it no long changes
#
# https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life
#
# Every cell interacts with its eight neighbours, which are the cells that are horizontally,
# vertically, or diagonally adjacent. At each step in time, the following transitions occur:
#   Any live cell with fewer than two live neighbours dies, as if by underpopulation.
#   Any live cell with two or three live neighbours lives on to the next generation.
#   Any live cell with more than three live neighbours dies, as if by overpopulation.
#   Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
#
# These rules, which compare the behavior of the automaton to real life, can be condensed into the following:
#   Any live cell with two or three live neighbours survives.
#   Any dead cell with three live neighbours becomes a live cell.
#   All other live cells die in the next generation. Similarly, all other dead cells stay dead.

require 'securerandom'
require 'ruby2d'
require_relative 'gol_cell'
require_relative 'gol_board'

# the graph paper background image has squares that are 36 pixels and the image is 1079 x 719
SQUARE_SIZE = 36
SQUARE_Z_DIM = 20
BACKGROUND_Z_DIM = 10
GRAPH_PAPER_WIDTH = 1079
GRAPH_PAPER_HEIGHT = 719

# colors for a multicolored board
COLORS = [['blue', 'green'], ['purple', 'red']]

# initialize board
def initialize_game_of_life
  set title: 'Random Start - Game of Life Simulation', width: GRAPH_PAPER_WIDTH, height: GRAPH_PAPER_HEIGHT

  # Use a background image of graph paper for board
  Image.new(
    'graph_paper.png',
    z: BACKGROUND_Z_DIM
  )
end


initialize_game_of_life

# create a board that is equal in size to background graph paper
board = GolBoard.new(20, 30)

create_new_board = true

# create a random board to start
# iterate until there are no changes
# then start over with another random board
update do
  if create_new_board
    puts "generating random board"
    board.random_start
    create_new_board = false
  else
    sleep 1
    num_changes = board.next_generation
    if num_changes.zero?
      puts "no changes, generating new random board"
      sleep 5
      create_new_board = true
    end
  end
end

show
