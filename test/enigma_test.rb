require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require_relative './test_helper'
require './lib/enigma'
require 'date'

class EnigmaTest < Minitest::Test
  def test_it_exists
    enigma = Enigma.new

    assert_instance_of Enigma, enigma
  end

  def test_encrypt_accepts_key_and_date_arguments
    enigma = Enigma.new
    message = "hello world"
    key = "02715"
    date = "040895"

    assert_equal "hello world", enigma.encrypt(message, key, date)[:encryption]
    assert_equal "02715", enigma.encrypt(message, key, date)[:key]
    assert_equal "040895", enigma.encrypt(message, key, date)[:date]
  end

  def test_encrypt_accepts_has_key_no_date
    enigma = Enigma.new
    message = "hello world"
    key = "02715"
    date = date = Date.today
    expected = date.strftime("%d%m%y")

    assert_equal "hello world", enigma.encrypt(message, key)[:encryption]
    assert_equal "02715", enigma.encrypt(message, key)[:key]
    assert_equal expected, enigma.encrypt(message, key)[:date]
  end

  def test_encrypt_accepts_no_key_no_date
    enigma = Enigma.new
    message = "hello world"
    Enigma.any_instance.stubs(:generate_key).returns("57145")
    date = Date.today
    expected = date.strftime("%d%m%y")

    assert_equal "hello world", enigma.encrypt(message)[:encryption]
    assert_equal "57145", enigma.encrypt(message)[:key]
    assert_equal expected, enigma.encrypt(message)[:date]
  end

  def test_generate_key
    enigma = Enigma.new

    assert_equal 5, enigma.generate_key.length
    assert_equal String, enigma.generate_key.class

    Enigma.any_instance.stubs(:generate_key).returns("57145")
    assert_equal "57145", enigma.generate_key
  end
end
