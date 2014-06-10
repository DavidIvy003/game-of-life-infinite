Tests:
======

To run tests, just type 'rake'


Display Output:
===============

To run script, use: './game.rb examples/5_by_5_matrix.txt'

To view print of multiple generations:
grid = Grid.new( 17, 17, 'examples/pulsar_matrix.txt') ;nil
puts grid.display
puts ""

50.times.each do |i|
  grid.next!
  puts grid.display
  puts ""
end


Instructions:
=============

Your task is to write a program to calculate the next
generation of Conway's game of life, given any starting
position. You start with a two dimensional grid of cells,
where each cell is either alive or dead. The grid is finite,
and no life can exist off the edges. When calculating the
next generation of the grid, follow these four rules:

1. Any live cell with fewer than two live neighbours dies,
   as if caused by underpopulation.
2. Any live cell with more than three live neighbours dies,
   as if by overcrowding.
3. Any live cell with two or three live neighbours lives
   on to the next generation.
4. Any dead cell with exactly three live neighbours becomes
   a live cell.

Examples: * indicates live cell, . indicates dead cell

Example input: (4 x 8 grid)
4 8
........
....*...
...**...
........

Example output:
4 8
........
...**...
...**...
........
