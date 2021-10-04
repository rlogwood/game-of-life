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

# the graph paper background image has squares that are 36 pixels for 20 rows x 30 columns,
# and the image is 1079 x 719 pixels
GRAPH_PAPER_IMAGE = 'graph_paper.png'
SQUARE_SIZE = 36
SQUARE_Z_DIM = 20
NUM_ROWS = 20
NUM_COLS = 30
BACKGROUND_Z_DIM = 10
GRAPH_PAPER_WIDTH = 1079
GRAPH_PAPER_HEIGHT = 719

SQUARE_SIZE = 18
NUM_ROWS = 80
NUM_COLS = 120

#SQUARE_SIZE = 9
#NUM_ROWS = 160
#NUM_COLS = 240


# speed
#ITERATION_PAUSE = 0.2 # seconds
ITERATION_PAUSE = 0.0 # seconds
SLOWER_ITERATION_PAUSE = 0.3 # seconds
STEADY_STATE_PAUSE = 2 # seconds
STEADY_STATE_ITERATIONS = 20
SLOW_AFTER_STEADY_STATE_ITERATIONS = 10


# colors for a multicolored board
COLORS = [['blue', 'green'], ['purple', 'red']]

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

change_count = []
# create a random board to start
# iterate until there are no changes
# then start over with another random board
update do
  if create_new_board
    board.random_start
    change_count = []
    board.go_slower = false
    create_new_board = false
  else
    if board.go_slower
      puts "we are slowed..."
      sleep SLOWER_ITERATION_PAUSE
    else
      sleep ITERATION_PAUSE
    end
    num_changes = board.next_generation
    #puts "num_changes: #{num_changes}"
    if num_changes.zero?
      sleep STEADY_STATE_PAUSE
      create_new_board = true
    else
      change_count.push num_changes
    end
  end

  #[slow_down, same] = reaching_steady_state(change_count)
  slow_down, same = reaching_steady_state(change_count)
  #  puts "slow_down:#{slow_down} same:#{same}"
  board.go_slower = slow_down

  if same
    create_new_board = true
    sleep STEADY_STATE_PAUSE
  end
end

show
