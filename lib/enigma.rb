require 'date'

class Enigma
  attr_reader :key,
              :offset

  def initialize
    @key = 0
    @offset = 0
  end

  def generate_random_key
    numbers = Array(0..9)
    @key = numbers.sample(5).join.to_i
  end

  def numerical_date
    Date.today.strftime("%d%m%y").to_i
  end

  def date_squared
    (numerical_date * numerical_date).to_s
  end

  def generate_offset
    @offset = date_squared[-4..-1].to_i
  end
end
