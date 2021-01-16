require 'date'

class Enigma

  def encrypt(message, key = generate_key, date = generate_date)

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
