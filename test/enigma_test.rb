require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
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
    Enigma.any_instance.stubs(:key).returns(57145)
    #
    assert_equal 57145, enigma.key
  end

  def test_it_can_use_todays_date_for_offset
    enigma = Enigma.new

    assert_equal 0, enigma.offset
    assert_equal 160121, enigma.numerical_date
    assert_equal "25638734641", enigma.date_squared
    enigma.generate_offset
    assert_equal 4641, enigma.offset
  end
end
