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
  it "is self aware" do
    cell = Cell.new('*')
    cell.is_alive?.must_equal true
  end

  it "can have neighbors" do
    cell = Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('.')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('.')
    cell.neighbors.length.must_equal 4
  end

  it "dies with less than 2 live neighbors" do
    cell = Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('.')
    cell.neighbors << Cell.new('.')
    cell.neighbors << Cell.new('.')
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal false
  end

  it "dies with more than 3 live neighbors" do
    cell = Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal false
  end

  it "lives if 2 or 3 neighbors live" do
    cell = Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('.')
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal true
    cell.neighbors.shift
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal true
  end

  it "reanimates with 3 live neighbors" do
    cell = Cell.new('.')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('*')
    cell.neighbors << Cell.new('.')
    cell.prepare_to_mutate!
    cell.mutate!
    cell.is_alive?.must_equal true
  end

end