module Generateable
  def generate_key
    (Array(0..9)).sample(5).join
  end

  def generate_date
    Date.today.strftime("%d%m%y")
  end

  def generate_alphabet_array
    Array("a".."z") << " "
  end

  def generate_offset(date)
    ((date.to_i) * (date.to_i)).to_s[-4..-1]
  end

  def generate_keys(key)
    { A: key[0..1],
      B: key[1..2],
      C: key[2..3],
      D: key[3..4] }.transform_values(&:to_i)
  end

  def generate_offsets(date)
    offset = generate_offset(date)
    { A: offset[0],
      B: offset[1],
      C: offset[2],
      D: offset[3] }.transform_values(&:to_i)
  end

  def generate_shifts(key, date)
    generate_keys(key).merge(generate_offsets(date)) do |letter, key, offset|
      key + offset
    end
  end
end
