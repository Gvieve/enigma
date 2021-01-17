require "./lib/enigma.rb"

message_input, encrypted_output = ARGV

message = File.open(message_input, "r").readlines.join.chomp

enigma = Enigma.new

message_output, key_output, date_output = enigma.encrypt(message).values

encrypted_message = File.open(encrypted_output, "w")
encrypted_message.write(message_output)
encrypted_message.close

puts "Created #{encrypted_output} with the key #{key_output} and date #{date_output}"
