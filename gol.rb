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
require_relative 'gol_util'

# ***********************************
# ** User changeable constants start

# ** board size dictated by factor  1=20x30, 2=40x60, 3=60x90, 4=80x120, 6=120x180, 9=180x270 (48,600 cells)
# ** NOTE: scale factors greater than 4 are pretty slow on my machine, but speed up as colonies die off
# ** NOTE: larger scale factors increase entertainment value :)
SQUARE_SCALE_FACTOR = 4 # should be a factor of 36

# ** speed
ITERATION_PAUSE = 0.0 # seconds
SLOWER_ITERATION_PAUSE = 0.3 # seconds
STEADY_STATE_PAUSE = 2 # seconds

# ** colors for a multicolored board
COLORS = [['blue', 'green'], ['purple', 'red']]
# ***********************************


# GOL Constants

# the graph paper background image has squares that are 36 pixels for 20 rows x 30 columns,
# and the image is 1079 x 719 pixels
GRAPH_PAPER_IMAGE = 'graph_paper.png'
GRAPH_SQUARE_SIZE = 36
SQUARE_Z_DIM = 20
GRAPH_NUM_ROWS = 20
GRAPH_NUM_COLS = 30
BACKGROUND_Z_DIM = 10
GRAPH_PAPER_WIDTH = 1079
GRAPH_PAPER_HEIGHT = 719

# board size calcs
SQUARE_SIZE = GRAPH_SQUARE_SIZE / SQUARE_SCALE_FACTOR
NUM_ROWS = GRAPH_NUM_ROWS * SQUARE_SCALE_FACTOR
NUM_COLS = GRAPH_NUM_COLS * SQUARE_SCALE_FACTOR

# cycle detection
CYCLE_DEPTH_LENGTH_CHECKS = [3, 4].freeze
STEADY_STATE_ITERATIONS = 20
SLOW_AFTER_STEADY_STATE_ITERATIONS = 10

# initialize board
def initialize_game_of_life
  set title: "Conway's Game of Life - (random restart w/right mouse click) ", width: GRAPH_PAPER_WIDTH, height: GRAPH_PAPER_HEIGHT

  # Use a background image of graph paper for board
  Image.new(
    GRAPH_PAPER_IMAGE,
    z: BACKGROUND_Z_DIM
  )

  # create a board that is equal in size to background graph paper
  board = GolBoard.new(NUM_ROWS, NUM_COLS)

  # regenerate random board on any key press
  on :key do |event|
    board.random_start
  end

  # regenerate random board on right mouse click
  on :mouse_down do |event|
    if event.button == :right
      board.random_start
    end
  end

  board
end

board = initialize_game_of_life


create_new_board = true

change_counts = []
# create a random board to start
# iterate until there are no changes
# then start over with another random board
update do
  if create_new_board
    board.random_start
    change_counts = []
    board.go_slower = false
    create_new_board = false
  else
    if board.go_slower
      print "."
      sleep SLOWER_ITERATION_PAUSE
    else
      sleep ITERATION_PAUSE
    end
    num_changes = board.next_generation
    if num_changes.zero?
      sleep STEADY_STATE_PAUSE
      create_new_board = true
    else
      change_counts.push num_changes
    end
  end

  board.go_slower, same = steady_state_check(change_counts)

  if same
    create_new_board = true
    sleep STEADY_STATE_PAUSE
  end
end

show
