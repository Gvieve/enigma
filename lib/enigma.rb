require 'date'
require_relative './validateable'
require_relative './generateable'

class Enigma
  include Validateable
  include Generateable

  def create_encrypted_alphabets(key, date)
    shifts = generate_shifts(key, date)
    shifts.values.map do |shift|
      generate_alphabet_array.rotate(shift)
    end
  end

  def create_decrypted_alphabets(key, date)
    shifts = generate_shifts(key, date)
    shifts.values.map do |shift|
      generate_alphabet_array.rotate(-shift)
    end
  end

  def convert_message_to_index(message)
    chars_message = message.downcase.chars
    alphabet = generate_alphabet_array
    chars_message.map do |letter|
     if alphabet.include?(letter)
       alphabet.index(letter)
     else
       letter
     end
    end
  end

  def index_msg_groups(message)
    index_msg = convert_message_to_index(message)
    index_msg.each_slice(4).map do |group|
      group
    end
  end

  def create_encrypted_message(message, key, date)
    index_msg_groups = index_msg_groups(message)
    encrypted_message = index_msg_groups.flat_map do |group|
      group.zip(create_encrypted_alphabets(key, date)).map do |number, alphabet|
        number.class == Integer ? alphabet[number] : number
      end
    end

    encrypted_message.join
  end

  def encrypt(message, key = generate_key, date = generate_date)
    if valid_input?(message, key, date)
      {encryption:  create_encrypted_message(message, key, date),
       key:         key,
       date:        date}
   end
  end

  def create_decrypted_message(message, key, date)
    index_msg_groups = index_msg_groups(message)
    decrypted_message = index_msg_groups.flat_map do |group|
      group.zip(create_decrypted_alphabets(key, date)).map do |index, alphabet|
        index.class == Integer ? alphabet[index] : index
      end
    end

    decrypted_message.join
  end

  def decrypt(message, key, date = generate_date)
    if valid_input?(message, key, date)
      {decryption:  create_decrypted_message(message, key, date),
       key:         key,
       date:        date}
    end
  end
end
