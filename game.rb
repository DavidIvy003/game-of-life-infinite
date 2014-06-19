#!/usr/bin/env ruby

require 'debugger'
require './grid'
require './cell'

class InvalidInput < Exception
end

class Game


  def initialize(inputfile)
    @history_size = 3
    @generation   = 0
    @delay        = 0.1
    @history      = []
    @grid         = Grid.new(inputfile)

    @history << @grid.display

    trap "SIGINT" do
      end_game!
    end
  end

  def run!
    while true
      puts @grid.display
      sleep @delay
      puts ""
      @grid.next!
      update_history!
    end
  end

  private

    def end_game! cycling = false
      message = "Generation #{@generation}"
      message += ", cycle repeats." if cycling
      puts message
      exit
    end

    def update_history!
      @generation += 1
      output = @grid.display

      end_game!(true) if @history.include? output
      @history << output
      @history.shift if @history.size > @history_size
    end
end

if __FILE__ == $0
  # this will only run if the script was the main, not load'd or require'd
  puts Game.new(ARGV[0]).run!
end
