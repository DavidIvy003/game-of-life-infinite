class Cell
  attr_accessor :alive, :next_state, :row, :column, :num_neighbours, :num_alive_neighbours

  def initialize state, row, col
    @alive      = state
    @row        = row
    @column     = col

    @next_state = @alive
  end

  def is_alive?
    @alive
  end

  def prepare_to_mutate!
    die_if_underpopulated
    die_if_overpopulated
    revive_if_born
  end

  def mutate!
    @alive = @next_state
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
      @num_alive_neighbours
    end
end