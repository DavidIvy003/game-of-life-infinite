class Cell
  attr_accessor :alive, :next_state, :row, :column, :num_neighbours

  def initialize state, row, col, grid
    @alive      = state
    @row        = row
    @column     = col
    @grid       = grid

    @next_state = @alive
  end

  def is_alive?
    @alive
  end

  def prepare_to_mutate!
    @num_neighbours = nil
    die_if_underpopulated
    die_if_overpopulated
    revive_if_born
  end

  def mutate!
    @alive = @next_state
    @grid.delete(self) unless @alive
  end

  def neighbors

    neighbours = []

    neighbours.push(@grid.cell_at(row - 1, column - 1, is_alive?))
    neighbours.push(@grid.cell_at(row - 1, column, is_alive?))
    neighbours.push(@grid.cell_at(row - 1, column + 1, is_alive?))

    neighbours.push(@grid.cell_at(row, column - 1, is_alive?))
    neighbours.push(@grid.cell_at(row, column + 1, is_alive?))

    neighbours.push(@grid.cell_at(row + 1, column - 1, is_alive?))
    neighbours.push(@grid.cell_at(row + 1, column, is_alive?))
    neighbours.push(@grid.cell_at(row + 1, column + 1, is_alive?))

    neighbours
  end

  def die!
    @next_state = false
  end

  def revive!
    @next_state = true
  end

  private

    def die_if_underpopulated
      die! if num_alive_neighbors < 2
    end

    def die_if_overpopulated
      die! if num_alive_neighbors > 3
    end

    def revive_if_born
      revive! if num_alive_neighbors == 3
    end

    def num_alive_neighbors
      @num_neighbours ||= neighbors.select{|n| n && n.is_alive?}.count
    end
end