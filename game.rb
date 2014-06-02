#!/usr/bin/env ruby

require 'debugger'

class InvalidInput < Exception
end

class Grid

  attr_accessor :grid

  def initialize columns, rows, file=nil
    @columns = columns
    @rows    = rows
    @grid    = build_grid file
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
    @grid.each do |row|
      row.each do |cell|
        cell.mutate!
      end
    end

    @grid.each do |row|
      row.each do |cell|
        cell.enforce!
      end
    end
  end

  private
    def build_grid file
      grid = []
      if File.exist? file.to_s
        File.read(file).split("\n").each do |row|
          grid << row.split(//).map{|state| Cell.new(state)}
        end
      else
        @rows.times.each do |row|
          grid << @columns.times.map {|x| Cell.new('.')}
        end
      end
      populate_neighbors grid
    end

    def populate_neighbors grid
      grid.each_with_index do |row, row_idx|
        row.each_with_index do |col, col_idx|
          grid = cell_neighbors grid, row_idx, col_idx
        end
      end
      return grid
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
end

class Cell
  attr_accessor :neighbors, :next_state

  def initialize state
    @alive = state == '*'
    @next_state = @alive
    @neighbors = []
  end

  def is_alive?
    @alive
  end

  def mutate!
    die_if_underpopulated
    die_if_overpopulated
    revive_if_born
  end

  def enforce!
    @alive = @next_state
  end

  private
    def die!
      @next_state = false
    end

    def revive!
      @next_state = true
    end

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
      neighbors.select{|n| n.is_alive?}.count
    end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  puts Grid.new(8,4).display
end
