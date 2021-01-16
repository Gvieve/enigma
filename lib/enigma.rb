class Enigma
  attr_reader :key

  def initialize
    @key = 0
  end

  def generate_random_key
    numbers = Array(0..9)
    @key = numbers.sample(5).join.to_i
  end
end
