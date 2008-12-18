require 'test/unit'

class Foo < Test::Unit::TestCase
  def test_truth
    response = assert false
    puts response.inspect
    puts @passed
    puts "??????????"
    rescue MiniTest::Assertion => e
    puts e.inspect
    puts "!!!!!!!!!"
  end
end
