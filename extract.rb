file = File.open('084.xor', 'rb')
key_size = 256; space_threshold = 30; space_ascii = 32
space_range_1 = (65..90); space_range_2 = (97..122)
count_arr = []; encr_key = {}
slices = file.each_byte.each_slice(key_size)
ciphertexts = slices.take(41)

xored = ciphertexts.map{|encr_msg| ciphertexts.map{|other_encr_msg| [other_encr_msg,encr_msg]}.map{|msg_pair| msg_pair.transpose.map{|zipped_chars| zipped_chars.reduce(){|a,b| a^b}}}.select(){|arr| arr.any?{|elem| elem != 0}}}
filtered = xored.map{|xored_msg_list| xored_msg_list.map{|xored_msg| xored_msg.each_with_index.map{|val,index| [val,index]}.select{|element| (space_range_1 === element[0] or space_range_2 === element[0] or element[0] == 0)}}}
filtered.each_with_index.map{|list_of_possible_spaces,index| count_arr[index] = {};list_of_possible_spaces.each{|list| list.each{ |pair| count_arr[index][pair[1]] = count_arr[index][pair[1]].to_i + 1 }}}
possible_spaces = count_arr.map{|count_hash| count_hash.select{|key,val| val > space_threshold }}
# uncovered_key_bytes = possible_spaces.map{|hash| hash.map{|key,val| key}}.flatten.uniq.sort
# p uncovered_key_bytes.length / key_size.to_f
possible_spaces.each_with_index.map{|hash,index| hash.map{|key,val| encr_key[key] ||= ciphertexts[index][key] ^ space_ascii }}
message  = 1

plaintext = ciphertexts.map{|encr_msg| encr_msg.each_with_index.map{|val,index| val ^ encr_key[index].to_i}.pack("c*")}
puts "recovered text:"
p plaintext[message]
# puts plaintext[message].length
# puts "provide correct plaintext"
correct_plaintext = File.open("converted.txt").read.unpack("c*")
# p correct_plaintext
# correct_plaintext = $stdin.readlines.join().unpack('c*')
# puts "ciphertext:"
# p ciphertexts[message]
puts "cleartext:"
p correct_plaintext.pack('c*')
p correct_plaintext.length
p final_key = ciphertexts[message].zip(correct_plaintext).map{|elem| elem[0] ^ elem[1]}
p final_key.length
# puts ciphertexts.map{|mess| mess.zip(final_key).map{|pair| pair.first ^ pair.last}.pack("c*")}
puts ciphertexts.map{|encr| encr.zip(final_key)}.flatten.map{|pair| pair[0] ^ pair[1]}.pack("c*")