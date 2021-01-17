require 'date'

class Enigma
  attr_reader :encrypted_alphabets

  def initialize
    @encrypted_alphabets = []
    @encrypted_message = []
  end

  def valid_message?(message)
    message.class == String
  end

  def valid_key?(key)
    (key.size == 5) &&
    (valid_message?(key)) &&
    (key.scan(/\D./).empty?)
  end

  def valid_date?(date)
    (date.size == 6) &&
    (valid_message?(date)) &&
    (date.scan(/\D./).empty?)
  end

  def valid_input?(*inputs)
    message, key, date, = inputs
    valid_message?(message) &&
    valid_key?(key) &&
    valid_date?(date)
  end

  def generate_key
    (Array(0..9)).sample(5).join
  end

  def generate_date
    Date.today.strftime("%d%m%y")
  end

  def alphabet_array
    Array("a".."z") << " "
  end

  def create_keys(key)
    { A: key[0..1],
      B: key[1..2],
      C: key[2..3],
      D: key[3..4] }.transform_values(&:to_i)
  end

  def offset(date)
    ((date.to_i) * (date.to_i)).to_s[-4..-1]
  end

  def create_offsets(date)
    offset = offset(date)
    { A: offset[0],
      B: offset[1],
      C: offset[2],
      D: offset[3] }.transform_values(&:to_i)
  end

  def create_shifts(key, date)
    create_keys(key).merge(create_offsets(date)) do |letter, key, offset|
      key + offset
    end
  end

  def create_encrypted_alphabets(key, date)
    shifts = create_shifts(key, date)

    shifts.values.map do |shift|
      @encrypted_alphabets << alphabet_array.rotate(shift)
    end

    @encrypted_alphabets
  end

  def convert_message_to_numbers(message)
    chars_message = message.downcase.chars
    chars_message.map do |letter|
     if alphabet_array.include?(letter)
       alphabet_array.index(letter)
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
      group.zip(@encrypted_alphabets).map do |(group, alphabet)|
        if group.class == Integer
          alphabet[group]
        else
          group
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
end
