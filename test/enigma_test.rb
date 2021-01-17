require_relative './test_helper'
require 'mocha/minitest'
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

    assert_equal Hash, enigma.encrypt(message, key, date).class
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

  def test_generate_date
    enigma = Enigma.new
    date = enigma.generate_date

    assert_equal 6, date.length
    assert_equal String, date.class
  end

  def test_it_has_valid_inputs?
    enigma = Enigma.new
    valid_msg = "hello world"
    valid_key = "02715"
    valid_date = "040895"

    assert_equal true, enigma.valid_input?(valid_msg, valid_key, valid_date)

    invalid_msg = 231
    invalid_key = 775241
    invalid_date = "040895"
    assert_equal false, enigma.valid_input?(invalid_msg, invalid_key, invalid_date)
  end

  def test_is_valid_message?
    enigma = Enigma.new
    valid = "Test"
    invalid1 = 1234

    # assert_equal true, enigma.valid_message?(valid)
    assert_equal true, enigma.valid_message?(valid)
    assert_equal false, enigma.valid_message?(invalid1)
  end

  def test_is_valid_key?
    enigma = Enigma.new
    valid = "12345"
    invalid1 = "123456"
    invalid2 = 12345
    invalid3 = "A12345"

    assert_equal true, enigma.valid_key?(valid)
    assert_equal false, enigma.valid_key?(invalid1)
    assert_equal false, enigma.valid_key?(invalid2)
    assert_equal false, enigma.valid_key?(invalid3)
  end

  def test_is_valid_date?
    enigma = Enigma.new
    valid = "123456"
    invalid1 = "12345"
    invalid2 = 123456
    invalid3 = "123A56"

    assert_equal true, enigma.valid_date?(valid)
    assert_equal false, enigma.valid_date?(invalid1)
    assert_equal false, enigma.valid_date?(invalid2)
    assert_equal false, enigma.valid_date?(invalid3)
  end

  def test_it_converts_date_to_offset
    enigma = Enigma.new
    message = "hello world"
    key = "02715"
    date = "040895"
    date_squared = (date.to_i) * (date.to_i)
    expected = date_squared.to_s[-4..-1]

    assert_equal expected, enigma.offset(date)
  end

  def test_convert_message_to_numbers
    enigma = Enigma.new
    message = "Hello world"
    converted = [7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3]

    assert_equal converted, enigma.convert_message_to_numbers(message)
  end

  def test_keys_hash_when_key_date_provided
    enigma = Enigma.new
    key = "02715"
    date = "040895"
    expected = { A: 2, B: 27, C: 71, D: 15 }

    assert_equal expected, enigma.create_keys(key)
  end

  def test_keys_hash_when_no_key_date_provided
    enigma = Enigma.new
    Enigma.any_instance.stubs(:generate_key).returns("67890")
    key = enigma.generate_key
    date = enigma.generate_date
    expected = { A: 67, B: 78, C: 89, D: 90 }

    assert_equal expected, enigma.create_keys(key)
  end

  def test_offset_hash_when_key_date_provided
    enigma = Enigma.new
    key = "02715"
    date = "040895"
    expected = { A: 1, B: 0, C: 2, D: 5 }

    assert_equal expected, enigma.create_offsets(date)
  end

  def test_offset_hash_when_no_key_date_provided
    enigma = Enigma.new
    # Enigma.any_instance.stubs(:generate_key).returns("67890")
    key = enigma.generate_key
    date = enigma.generate_date
    expected = { A: 4, B: 6, C: 4, D: 1 }

    assert_equal expected, enigma.create_offsets(date)
  end
end
