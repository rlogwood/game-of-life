# create a board for Game of Life
class GolBoard
  attr_reader :num_rows, :num_cols

  # create a board of dimension num_rows by num_cols
  def initialize(num_rows, num_cols)
    @num_rows = num_rows
    @num_cols = num_cols
    @cells = Array.new(@num_rows) { |row| Array.new(@num_cols) { |col| GolCell.new(row, col) } }
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

  # get the cell neighbor for the given row, column delta
  # return nil for invalid coordinates
  def neighbor(cell, row_delta, col_delta)
    return nil if row_delta.zero? && col_delta.zero?

    row = cell.row + row_delta
    col = cell.col + col_delta

    return nil if row.negative? || col.negative? || row >= @num_rows || col >= @num_cols

    @cells[row][col]
  end

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
