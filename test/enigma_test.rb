require_relative './test_helper'
require 'mocha/minitest'
require './lib/enigma'
require 'date'

class EnigmaTest < Minitest::Test
  def test_it_exists
    enigma = Enigma.new

    assert_instance_of Enigma, enigma
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
    key = enigma.generate_key
    Enigma.any_instance.stubs(:generate_date).returns("170121")
    date = enigma.generate_date
    expected = { A: 4, B: 6, C: 4, D: 1 }

    assert_equal expected, enigma.create_offsets(date)
  end

  def test_create_shifts_hash
    enigma = Enigma.new
    key = "02715"
    date = "040895"
    expected = { A: 3, B: 27, C: 73, D: 20 }

    assert_equal expected, enigma.create_shifts(key, date)
  end

  def test_create_encrypted_alphabets
    enigma = Enigma.new
    key = "02715"
    date = "040895"
    enigma.create_shifts(key, date)
    enigma.create_encrypted_alphabets(key, date)
    expected1 = "d"
    expected2 = "a"
    expected3 = "t"
    expected4 = "u"

    assert_equal expected1, enigma.encrypted_alphabets[0].first
    assert_equal expected2, enigma.encrypted_alphabets[1].first
    assert_equal expected3, enigma.encrypted_alphabets[2].first
    assert_equal expected4, enigma.encrypted_alphabets[3].first
  end

  def test_convert_message_to_numbers
    enigma = Enigma.new
    message = "Hello world"
    converted1 = [7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3]

    assert_equal converted1, enigma.convert_message_to_numbers(message)

    message = "Hello world!"
    converted2 = [7, 4, 11, 11, 14, 26, 22, 14, 17, 11, 3, "!"]
    assert_equal converted2, enigma.convert_message_to_numbers(message)
  end

  def test_create_numerical_msg_groups
    enigma = Enigma.new
    message = "Hello world"
    converted1 = [[7, 4, 11, 11], [14, 26, 22, 14], [17, 11, 3]]

    assert_equal converted1, enigma.numerical_msg_groups(message)

    message = "Hello world!"
    converted2 = [[7, 4, 11, 11], [14, 26, 22, 14], [17, 11, 3, "!"]]
    assert_equal converted2, enigma.numerical_msg_groups(message)
  end

  def test_create_encrypted_message
    enigma = Enigma.new
    message = "Hello world"
    key = "02715"
    date = "040895"
    converted1 = "keder ohulw"

    assert_equal converted1, enigma.create_encrypted_message(message, key, date)

    message = "Hello world!"
    converted2 = "keder ohulw!"
    assert_equal converted2, enigma.create_encrypted_message(message, key, date)
  end

  def test_encrypt_accepts_key_and_date_arguments
    enigma = Enigma.new
    message = "hello world"
    key = "02715"
    date = "040895"

    assert_equal Hash, enigma.encrypt(message, key, date).class
    assert_equal "keder ohulw", enigma.encrypt(message, key, date)[:encryption]
    assert_equal "02715", enigma.encrypt(message, key, date)[:key]
    assert_equal "040895", enigma.encrypt(message, key, date)[:date]

    message = "heLlo worlD!"
    assert_equal "keder ohulw!", enigma.encrypt(message, key, date)[:encryption]
  end

  def test_encrypt_accepts_has_key_no_date
    enigma = Enigma.new
    message = "hello world"
    key = "02715"
    Enigma.any_instance.stubs(:generate_date).returns("170121")
    date = enigma.generate_date
    # expected = date.strftime("%d%m%y")

    assert_equal "nkfaufqdxry", enigma.encrypt(message, key)[:encryption]
    assert_equal "02715", enigma.encrypt(message, key)[:key]
    assert_equal "170121", enigma.encrypt(message, key)[:date]
  end

  def test_encrypt_accepts_no_key_no_date
    enigma = Enigma.new
    message = "hello world"
    Enigma.any_instance.stubs(:generate_key).returns("57145")
    date = Date.today
    expected = date.strftime("%d%m%y")

    assert_equal "oacdvwngyhv", enigma.encrypt(message)[:encryption]
    assert_equal "57145", enigma.encrypt(message)[:key]
    assert_equal expected, enigma.encrypt(message)[:date]
  end

  def test_it_decrypts_with_key_and_date
    enigma = Enigma.new
    message = "keder ohulw"
    key = "02715"
    date = "040895"

    assert_equal Hash, enigma.decrypt(message, key, date).class
    assert_equal "hello world", enigma.decrypt(message, key, date)[:decryption]
    assert_equal "02715", enigma.decrypt(message, key, date)[:key]
    assert_equal "040895", enigma.decrypt(message, key, date)[:date]

    message = "keder ohulw!"
    assert_equal "hello world!", enigma.decrypt(message, key, date)[:decryption]
  end

  def test_decrypt_accepts_has_key_no_date
    enigma = Enigma.new
    message = "nkfaufqdxry"
    key = "02715"
    Enigma.any_instance.stubs(:generate_date).returns("170121")
    date = enigma.generate_date

    assert_equal "hello world", enigma.decrypt(message, key)[:decryption]
    assert_equal "02715", enigma.decrypt(message, key)[:key]
    assert_equal "170121", enigma.decrypt(message, key)[:date]
  end
end
