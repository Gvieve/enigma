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
  ## date_squared(date)[-4..-1].to_i
  #
end
