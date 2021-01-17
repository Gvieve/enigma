require "./lib/enigma.rb"

encrypted_input, decrypted_output, key_input, date_input = ARGV

encrypted_message = File.open(encrypted_input, "r").readlines.join.chomp

enigma = Enigma.new

message_output, key_output, date_output = enigma.decrypt(encrypted_message, key_input, date_input).values

decrypted_message = File.open(decrypted_output, "w")
decrypted_message.write(message_output)
decrypted_message.close

puts "Created #{decrypted_output} with the key #{key_output} and date #{date_output}"
