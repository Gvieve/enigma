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

  def generate_shifts(key, date)
    offset = generate_offset(date)
    { A: key[0..1].to_i + offset[0].to_i,
      B: key[1..2].to_i + offset[1].to_i,
      C: key[2..3].to_i + offset[2].to_i,
      D: key[3..4].to_i + offset[3].to_i }
  end
end
