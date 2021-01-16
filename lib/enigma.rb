require 'date'

class Enigma
  attr_reader :message,
              :key,
              :date

  def encrypt(message, key = nil, date = nil)
    {:encryption => message,
     :key => store_key(key),
     :date => store_date(key, date)}
  end

  def store_key(key)
    if key.nil?
      key = generate_key
    elsif key.length == 5
      key = key
    elsif key.length == 6
      key = generate_key
    end
  end

  def store_date(key, date)
    if date.nil? && key.nil?
      date = generate_date
    elsif date.nil? && key.length == 6
      date = key
    elsif date.nil? && key.length == 5
      date = generate_date
    elsif date.length == 6
      date = date
    end
  end

  def generate_key
    numbers = Array(0..9)
    numbers.sample(5).join
  end

  def generate_date
    date = Date.today
    date.strftime("%d%m%y")
  end

  # date_squared(date)[-4..-1].to_i
  #
  # def numerical_date(date = Date.today)
  #   # require "pry"; binding.pry
  #   if date.class == String
  #     date
  #   else
  #     date.strftime("%d%m%y")
  #   end
  # end
  #
  # def date_squared(date)
  #   # require "pry"; binding.pry
  #   ((numerical_date(date).to_i) * (numerical_date(date).to_i)).to_s
  # end
  #
  #
end
