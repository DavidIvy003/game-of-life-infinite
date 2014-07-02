require 'simplecov'
require 'turn/autorun'

SimpleCov.start do
  add_filter 'vendor'
end

require './cell'

describe Cell do
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