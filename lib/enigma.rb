require 'date'
require_relative './validateable'
require_relative './generateable'

class Enigma
  include Validateable
  include Generateable

  def initialize
    @encrypted_alphabets = []
    @decrypted_alphabets = []
  end

  def create_encrypted_alphabets(key, date)
    shifts = generate_shifts(key, date)
    shifts.values.map do |shift|
      @encrypted_alphabets << generate_alphabet_array.rotate(shift)
    end

    @encrypted_alphabets
  end

  def create_decrypted_alphabets(key, date)
    shifts = generate_shifts(key, date)

    shifts.values.map do |shift|
      @decrypted_alphabets << generate_alphabet_array.rotate(-shift)
    end

    @decrypted_alphabets
  end

  def convert_message_to_numbers(message)
    chars_message = message.downcase.chars
    chars_message.map do |letter|
     if generate_alphabet_array.include?(letter)
       generate_alphabet_array.index(letter)
     else
       letter
     end
    end
  end

  def numerical_msg_groups(message)
    numerical_msg = convert_message_to_numbers(message)

    numerical_msg.each_slice(4).map do |group|
      group
    end
  end

  def create_encrypted_message(*values)
    message, key, date = values
    numerical_msg_groups = numerical_msg_groups(message)
    create_encrypted_alphabets(key, date)

    encrypted_message = numerical_msg_groups.flat_map do |group|
      group.zip(@encrypted_alphabets).map do |number, alphabet|
        if number.class == Integer
          alphabet[number]
        else
          number
        end
      end
    end

    encrypted_message.join
  end

  def encrypt(message, key = generate_key, date = generate_date)
    valid_input?(message, key, date)

    {:encryption => create_encrypted_message(message, key, date),
     :key => key,
     :date => date}
  end

  def create_decrypted_message(*values)
    message, key, date = values
    numerical_msg_groups = numerical_msg_groups(message)
    create_decrypted_alphabets(key, date)

    decrypted_message = numerical_msg_groups.flat_map do |group|
      group.zip(@decrypted_alphabets).map do |number, alphabet|
        if number.class == Integer
          alphabet[number]
        else
          number
        end
      end
    end

    decrypted_message.join
  end

  def decrypt(message, key, date = generate_date)
    valid_input?(message, key, date)

    {:decryption => create_decrypted_message(message, key, date),
     :key => key,
     :date => date}
  end
end
