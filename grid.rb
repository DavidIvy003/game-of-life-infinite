class Grid

  attr_accessor :grid

  def initialize file_name = ""
    raise "No file with name: #{file_name}" unless File.exist? file_name
    file     = File.read(file_name).split("\n")
    @rows    = file.count
    @columns = file.first.split(//).count
    @grid    = build_from_file file
    populate_neighbors!
  end

  def display
    [].tap { |output|
      output << @grid.map{|row| row.map{|cell| (cell.is_alive? ? '*' : '.')}.join}
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

  private
    def build_from_file file
      grid = []
      file.each do |row|
        grid << row.split(//).map{|state| Cell.new(state)}
      end
      grid
    end

    def populate_neighbors!
      each_cell_with_indexes do |col, row_idx, col_idx|
        @grid = cell_neighbors @grid, row_idx, col_idx
      end
    end

    def cell_neighbors grid, cell_row, cell_col
      cell = grid[cell_row][cell_col]
      potential_neighbors(cell_row).each do |row_idx|
        potential_neighbors(cell_col).each do |col_idx|
          if is_neighbor? cell_row, cell_col, row_idx, col_idx
            cell.neighbors << grid[row_idx][col_idx]
          end
        end
      end
      return grid
    end

    def within_grid? row_idx, col_idx
      ((row_idx >= 0 and row_idx < @rows - 1) and
          (col_idx >= 0 and col_idx < @rows - 1))
    end

    def potential_neighbors idx
      [idx - 1, idx, idx + 1]
    end

    def is_neighbor? cell_row, cell_col, row_idx, col_idx
      (!(row_idx == cell_row and col_idx == cell_col) and
        within_grid?(row_idx, col_idx))
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
