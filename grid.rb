class Grid

  ALIVE = '*'
  DEAD = '.'

  attr_accessor :grid

  def initialize file_name = ""
    raise "No file with name: #{file_name}" unless File.exist? file_name
    file     = File.read(file_name).split("\n")
    @rows    = file.count
    @columns = file.first.split(//).count
    @grid    = build_from_file file
  end

  def display
    [].tap { |output|
      output << @grid.map{|row| row.map{|cell| (cell.is_alive? ? ALIVE : DEAD)}.join}
    }.join("\n")
  end

  def meaning
    42
  end

  def next!
    each_cell do |cell|
      cell.prepare_to_mutate!
    end

    each_cell do |cell|
      cell.mutate!
    end
  end

  def cell_at(x, y)
    @grid[x][y] if @grid[x]
  end

  private
    def build_from_file file
      grid = []
      file.each_with_index do |row, r_idx|
        grid_row = []
        row.split(//).each_with_index do |state, c_idx|
          grid_row << Cell.new(state == ALIVE, r_idx, c_idx, self)
        end
        grid << grid_row
      end
      grid
    end

    def each_cell
      @grid.each do |row|
        row.each do |cell|
          yield cell
        end
      end
    end

    def each_cell_with_indexes
      @grid.each_with_index do |row, row_idx|
        row.each_with_index do |cell, col_idx|
          yield cell, row_idx, col_idx
        end
      end
    end
end
