require 'date'

class Enigma

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

  def encrypt(message, key = generate_key, date = generate_date)
    valid_input?(message, key, date)

    {:encryption => message,
     :key => key,
     :date => date}
  end

  def generate_key
    (Array(0..9)).sample(5).join
  end

  def generate_date
    Date.today.strftime("%d%m%y")
  end

  def offset(date)
    ((date.to_i) * (date.to_i)).to_s[-4..-1]
  end

  def alphabet_array
    Array("a".."z") << " "
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

  def create_keys(key)
    { A: key[0..1],
      B: key[1..2],
      C: key[2..3],
      D: key[3..4] }.transform_values(&:to_i)
  end

  #create Hash for keys and hash for offsets
  # keys = {A: key[0..1], B: key[1..2], etc}.transform_values(&:to_i)
  # offsets = {A: offset[0], B: offset[1], etc}.transform_values(&:to_i)

  # Merge those two hashes together and add values to on another
  # new_hash = keys.merge(offsets) {|letter, key, offset| key + offset}

  #create an array of arrays that has the cipher codes for A-D
  # rotated_letters = alpha.rotate(new_hash[value])
  # cipher_arrays << rotated_letters

  # create groups of letters_to_nums that will be zipped with cipher_arrays
  # grouped_l_to_n = letters_to_nums.each_slice(4).map {|group| group}

  # if that last element ends up having less than 4 elements move to own array
  # leftovers = grouped_l_to_n.pop if grouped_l_to_n.last.size < 4

  # iterate over grouped_l_to_n
  # zip one group with ciper
  # ciphered_msg = grouped_l_to_n.flat_map do |group|
    # group.zip(cipher).map do |(group, cipher)|
      # if group.class == Integer
      #   cipher[group]
      # else
      #   group
      # end
    #end
  #end

  #zip leftovers with ciphers and add to end of ciphered_msg unless nil
  # ciphered_msg.join
end
