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
    grid = Grid.new( 'examples/2_by_2.txt')
    grid.next!
    disp = grid.display
    disp.scan(/\*/).count.must_equal 4
  end

  it "expands the grid if needed" do
    grid = Grid.new( 'examples/4_by_3.txt')
    disp = grid.display
    rows = disp.split("\n")
    rows.count.must_equal 4
    rows.first.split(//).count.must_equal 3

    grid.next!
    disp = grid.display
    rows = disp.split("\n")
    rows.count.must_equal 5
    rows.first.split(//).count.must_equal 4
  end

  it "works in an infinite grid" do
    grid = Grid.new( 'examples/4_by_3.txt')
    grid.next!
    disp = grid.display
    disp.scan(/\*/).count.must_equal 3
  end

  it "persists for multiple generations" do
    grid = Grid.new( 'examples/30_by_30_acorn.txt')
    disp = grid.display
    disp.scan(/\*/).count.must_equal 7
    grid.next!
    disp = grid.display
    disp.scan(/\*/).count.must_equal 8
    grid.next!
    disp = grid.display
    disp.scan(/\*/).count.must_equal 10
  end
end

describe Cell do
  let(:grid) { Grid.new('examples/4_by_4_blank.txt') }

  it "is self aware" do
    cell = Cell.new(true, 1, 2)
    cell.is_alive?.must_equal true
  end

  it "has coordinates" do
    cell = Cell.new(true, 1, 2)
    cell.row.must_equal 1
    cell.column.must_equal 2
  end

  it "dies with less than 2 live neighbors" do
    cell = Cell.new(true, 1, 2)
    cell.num_alive_neighbours = 1
    cell.prepare_to_mutate!
    cell.is_alive?.must_equal true
    cell.mutate!
    cell.is_alive?.must_equal false
  end

  it "dies with more than 3 live neighbors" do
    cell = Cell.new(true, 1, 1)
    cell.num_alive_neighbours = 4
    cell.prepare_to_mutate!
    cell.is_alive?.must_equal true
    cell.mutate!
    cell.is_alive?.must_equal false
  end

  it "lives if 2 neighbors live" do
    cell = Cell.new(true, 1, 1)
    cell.num_alive_neighbours = 2
    cell.prepare_to_mutate!
    cell.is_alive?.must_equal true
    cell.mutate!
    cell.is_alive?.must_equal true
  end

  it "lives if 3 neighbors live" do
    cell = Cell.new(true, 1, 1)
    cell.num_alive_neighbours = 3
    cell.prepare_to_mutate!
    cell.is_alive?.must_equal true
    cell.mutate!
    cell.is_alive?.must_equal true
  end

  it "reanimates with 3 live neighbors" do
    cell = Cell.new(false, 1, 1)
    cell.num_alive_neighbours = 3
    cell.prepare_to_mutate!
    cell.is_alive?.must_equal false
    cell.mutate!
    cell.is_alive?.must_equal true
  end

end