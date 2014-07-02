require 'simplecov'
require 'turn/autorun'

SimpleCov.start do
  add_filter 'vendor'
end

require './grid'

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