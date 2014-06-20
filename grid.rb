class Grid

  ALIVE = '*'
  DEAD = '.'

  attr_accessor :grid

  def initialize file_name = ""
    raise "No file with name: #{file_name}" unless File.exist? file_name
    file     = File.read(file_name).split("\n")
    @rows    = file.count - 1
    @columns = file.first.split(//).count - 1

    @row_low     = 0
    @columns_low = 0

    @grid    = build_from_file file
  end

  def display
    output_grid = []
    (@row_low..@rows).each do |r_idx|
      o_row = []
      (@columns_low..@columns).each do |c_idx|
        cell = cell_at(r_idx, c_idx)
        o_row << ((cell && cell.is_alive?) ? '*' : '.')
      end
      output_grid << o_row
    end

    [].tap { |output|
      output << output_grid.map{|row| row.map{|cell| cell }.join}
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

  def cell_at x, y, create_cell = false
    cell = grid.select {|c| c.row == x && c.column == y}.first
    if cell.nil? and create_cell
      cell = Cell.new(false, x, y, self)
      @grid << cell

      @row_low     = x if @row_low > x
      @rows        = x if @rows < x
      @columns_low = y if @columns_low > y
      @columns     = y if @columns < y
    end
    cell
  end

  def delete cell
    # debugger if cell.row == 2 and cell.column == 1
    grid.delete_if {|c| c == cell}
  end

  private
    def build_from_file file
      grid = []
      file.each_with_index do |row, r_idx|
        row.split(//).each_with_index do |state, c_idx|
          grid << Cell.new(state == ALIVE, r_idx, c_idx, self)
        end
      end
      grid
    end

    def each_cell
      @grid.each do |cell|
        yield cell
      end
    end
end
