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