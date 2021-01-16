require 'minitest/autorun'
require 'minitest/pride'
require_relative './test_helper'
require './lib/enigma'

class EnigmaTest < Minitest::Test
  def test_it_exists
    enigma = Enigma.new

    assert_instance_of Enigma, enigma
  end

  def test_it_can_generate_key
    enigma = Enigma.new

    assert_equal 0, enigma.key
    enigma.generate_random_key
    # enigma.stubs(:key).returns(57145)
    #
    assert_equal 57145, enigma.key
  end
end
