file = File.open('084.xor', 'rb')
#puts file.bytes.each_slice(256).take(41).combination(2).map{|slice| slice.transpose.map{|x| x.reduce(){|a,b| a^b }}.pack("c*") }
key_size = 256; space_threshold = 32; space_ascii = 32
space_range_1 = (65..90); space_range_2 = (97..122)
count_arr = []; encr_key = {}
slices = file.bytes.each_slice(key_size)
ciphertexts = slices.take(41)

xored = ciphertexts.map{|encr_msg| ciphertexts.map{|other_encr_msg| [other_encr_msg,encr_msg]}.map{|msg_pair| msg_pair.transpose.map{|zipped_chars| zipped_chars.reduce(){|a,b| a^b}}}.select(){|arr| arr.any?{|elem| elem != 0}}}
filtered = xored.map{|xored_msg_list| xored_msg_list.map{|xored_msg| xored_msg.each_with_index.map{|val,index| [val,index]}.select{|element| (space_range_1 === element[0] or space_range_2 === element[0] or element[0] == 0)}}}
filtered.each_with_index.map{|list_of_possible_spaces,index| count_arr[index] = {};list_of_possible_spaces.each{|list| list.each{ |pair| count_arr[index][pair[1]] = count_arr[index][pair[1]].to_i + 1 }}}
possible_spaces = count_arr.map{|count_hash| count_hash.select{|key,val| val > space_threshold }}
# uncovered_key_bytes = possible_spaces.map{|hash| hash.map{|key,val| key}}.flatten.uniq.sort
# p uncovered_key_bytes.length / key_size.to_f

possible_spaces.each_with_index.map{|hash,index| hash.map{|key,val| encr_key[key] ||= ciphertexts[index][key] ^ space_ascii }}

message  = 2
# puts "recovered encryption key:"
# p encr_key.to_a.sort_by{|pair| pair[0]}
# p encr_key
# puts "ciphertext:"
# p ciphertexts[message]
plaintext = ciphertexts.map{|encr_msg| encr_msg.each_with_index.map{|val,index| val ^ encr_key[index].to_i}.pack("c*")}
puts "recovered chars:"
p plaintext[message].chars.each_with_index.map{|char,index| [char,index]}
puts "recovered text:"
puts plaintext[message]
puts "missing key bytes:"
missing_key_bytes = ((0..255).to_a - encr_key.map{|key,val|key}).sort
p missing_key_bytes
puts "provide correct plaintext ASCII codes for missing bytes (separated by commas)"
correct_chars_codes = gets().chomp().split(',').map{|elem| elem.to_i}
correct_chars_codes.zip(missing_key_bytes).each{|elem| encr_key[elem[0]] = elem[1]}
corrected_plaintext = ciphertexts.map{|encr_msg| encr_msg.each_with_index.map{|val,index| val ^ encr_key[index].to_i}.pack("c*")}
puts corrected_plaintext
# p correct_chars.split(',')
# p encr_key.length / key_size.to_f