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
      @visual&.remove
    end
  end

  private

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

    
end
