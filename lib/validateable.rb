module Validateable
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
end
