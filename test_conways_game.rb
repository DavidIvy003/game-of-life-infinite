require 'simplecov'
require 'turn/autorun'

SimpleCov.start do
  add_filter 'vendor'
end

require './game'

describe Game do

  it "returns error if no input file" do
    exception = assert_raises(RuntimeError) {
      grid = Game.new( 'nil' )
    }
    assert_equal( "No file with name: nil", exception.message )
  end

end

describe Grid do

  it "accepts input from a file" do
    grid = Grid.new( 'examples/9_by_5_matrix.txt')
    disp = grid.display
    disp.scan(/\*/).count.must_equal 4
  end

  it "must perserve rows and columns" do
    grid = Grid.new( 'examples/4_by_4_blank.txt')
    disp = grid.display
    disp.scan(/\./).count.must_equal 16
  end

  it "calculates the next generation of square" do
    grid = Grid.new( 'examples/5_by_5_matrix.txt')
    grid.next!
    disp = grid.display
    disp.scan(/\*/).count.must_equal 6
  end

  it "calculates the next generation of rectangle" do
    grid = Grid.new( 'examples/9_by_6_matrix.txt')
    grid.next!
    disp = grid.display
    disp.scan(/\*/).count.must_equal 3
  end
end

describe Cell do
  let(:grid) { Grid.new('examples/4_by_4_blank.txt') }

  it "is self aware" do
    cell = Cell.new(true, 1, 2, grid)
    cell.is_alive?.must_equal true
  end

  it "has coordinates" do
    cell = grid.cell_at(1,2, true)
    cell.alive = true
    cell.row.must_equal 1
    cell.column.must_equal 2
  end

  it "can have neighbors" do
    cell = grid.cell_at(1,1, true)
    cell.alive = true
    grid.cell_at(1,0, true).alive = true
    grid.cell_at(1,0, true).alive = true
    cell.neighbors.length.must_equal 8
  end

  it "dies with less than 2 live neighbors" do
    cell = grid.cell_at(1,1, true)
    cell.alive = true
    grid.cell_at(1,0, true).alive = true
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal false
  end

  it "dies with more than 3 live neighbors" do
    cell = grid.cell_at(1,1, true)
    cell.alive = true
    grid.cell_at(1,0, true).alive = true
    grid.cell_at(1,2, true).alive = true
    grid.cell_at(0,1, true).alive = true
    grid.cell_at(2,1, true).alive = true
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal false
  end

  it "lives if 2 neighbors live" do
    cell = grid.cell_at(1,1, true)
    cell.alive = true
    cell.next_state = true
    grid.cell_at(1,0, true).alive = true
    grid.cell_at(0,1, true).alive = true
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal true
  end

  it "lives if 3 neighbors live" do
    cell = grid.cell_at(1,1, true)
    cell.alive = true
    cell.next_state = true
    grid.cell_at(1,0, true).alive = true
    grid.cell_at(0,1, true).alive = true
    grid.cell_at(1,2, true).alive = true
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal true
  end

  it "reanimates with 3 live neighbors" do
    cell = grid.cell_at(1,1, true)
    cell.alive = true
    grid.cell_at(1,0, true).alive = true
    grid.cell_at(1,2, true).alive = true
    grid.cell_at(0,1, true).alive = true
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal true
  end

end