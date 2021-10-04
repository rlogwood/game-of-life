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

# the graph paper has squares that are 36 pixels
SQUARE_SIZE = 36
SQUARE_Z_DIM = 20

# colors for a multicolored board
COLORS = [['blue', 'green'], ['purple', 'red']]

# initialize board
def initialize_game_of_life
  set title: 'Game of Life', background: 'navy', width: 1079, height: 719

  # Use a background image of graph paper for board
  Image.new(
    'graph_paper.png',
    width: 1079, height: 719,
    z: 10
  )
end


# utility function to create a square for board
def square_at(y, x, color = COLORS[x % 2][y % 2])
  x_pos = x * SQUARE_SIZE
  y_pos = y * SQUARE_SIZE
  #puts "x:#{x}, y:#{y}, color:#{color}"
  sq = Square.new(
    x: x_pos, y: y_pos,
    size: SQUARE_SIZE,
    color: color,
    z: SQUARE_Z_DIM
  )
end


# representation of a cell in the game of life board
class GolCell
  attr_reader :row, :col, :alive, :visual

  def initialize(row, col)
    @row = row
    @col = col
    @alive = false
    @visual = nil
    @next_state = nil
  end

  # set the cell's alive value and update the visual as needed
  def alive=(value)
    return if value == @alive
    @alive = value

    if @alive
      if @visual
        @visual.add
      else
        @visual = square_at(@row, @col, color = COLORS[col % 2][row % 2])
      end
    else
      @visual&.remove # unless @visual.nil?
    end
  end

  #   Any live cell with two or three live neighbours survives.
  #   Any dead cell with three live neighbours becomes a live cell.
  #   All other live cells die in the next generation. Similarly, all other dead cells stay dead.
  def next_generation(neighbors)
    alive_neighbors = neighbors.select(&:alive)
    @next_state = if @alive
                    alive_neighbors.length == 2 || alive_neighbors.length == 3
                  else
                    alive_neighbors.length == 3
                  end
  end

  # update the cell's alive state to the next generation state
  def update_generation
    return if @next_state.nil?

    state_changed = self.alive != @next_state
    self.alive = @next_state
    @next_state = nil
    state_changed
  end
end

# create a board for Game of Life
class GolBoard
  attr_reader :num_rows, :num_cols

  # create a board of dimension num_rows by num_cols
  def initialize(num_rows, num_cols)
    @num_rows = num_rows
    @num_cols = num_cols
    @cells = Array.new(@num_rows) { |row| Array.new(@num_cols) { |col| GolCell.new(row, col) } }
  end

  # get the cell neighbor for the given row, column delta
  # return nil for invalid coordinates
  def neighbor(cell, row_delta, col_delta)
    return nil if row_delta.zero? && col_delta.zero?

    row = cell.row + row_delta
    col = cell.col + col_delta

    return nil if row.negative? || col.negative? || row >= @num_rows || col >= @num_cols

    @cells[row][col]
  end

  # progress to next generation
  # @return number of changes in this generation
  def next_generation
    (0...@num_rows).each do |y|
      (0...@num_cols).each do |x|
        @cells[y][x].next_generation(neighbors(y, x))
      end
    end

    num_state_changes = 0
    (0...@num_rows).each do |y|
      (0...@num_cols).each do |x|
        num_state_changes += 1 if @cells[y][x].update_generation
      end
    end

    num_state_changes
  end

  # create a random board
  def random_start
    (0...@num_rows).each do |y|
      (0...@num_cols).each do |x|
        alive1 = SecureRandom.random_number(2) == 1
        alive2 = SecureRandom.random_number(2) == 1
        @cells[y][x].alive = alive1 && alive2
      end
    end
  end

  private

  # @return array of GolCell neighbors for given coordinates
  def neighbors(y, x)
    cell = @cells[y][x]
    neighbors = []
    [0, -1, 1].each do |row_delta|
      [0, -1, 1].each do |col_delta|
        neighbor = neighbor(cell, row_delta, col_delta)
        neighbors.push neighbor unless neighbor.nil?
      end
    end
    neighbors
  end

end


# create a board that is equal in size to background graph paper
board = GolBoard.new(20, 30)

initialize_game_of_life

create_new_board = true

# create a random board to start
# iterate until there are no changes
# then start over with another random board
update do
  if create_new_board
    board.random_start
    create_new_board = false
  else
    sleep 1
    num_changes = board.next_generation
    if num_changes.zero?
      puts "finished this session"
      sleep 5
      create_new_board = true
    end
  end
end

show
