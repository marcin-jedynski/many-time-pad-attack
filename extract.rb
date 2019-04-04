file = File.open('084.xor', 'r')
message  = 2; key_size = 256; space_threshold = 30; space_ascii = 32; 
space_range_1 = (65..90); space_range_2 = (97..122)
count_arr = []; encr_key = {}
slices = file.to_a.flatten.reduce(){|elem, sum| elem+sum}.bytes#.join().bytes.reverse!.each_slice(key_size).to_a
ciphertexts = slices
ciphertexts = ciphertexts.reverse!.each_slice(key_size).to_a.reverse!.map{|arr| arr.reverse!}
ciphertexts.shift
xored = ciphertexts.map{|encr_msg| ciphertexts.map{|other_encr_msg| [other_encr_msg,encr_msg]}.map{|msg_pair| msg_pair.transpose.map{|zipped_chars| zipped_chars.reduce(){|a,b| a^b}}}.select(){|arr| arr.any?{|elem| elem != 0}}}
filtered = xored.map{|xored_msg_list| xored_msg_list.map{|xored_msg| xored_msg.each_with_index.map{|val,index| [val,index]}.select{|element| (space_range_1 === element[0] or space_range_2 === element[0] or element[0] == 0)}}}
filtered.each_with_index.map{|list_of_possible_spaces,index| count_arr[index] = {};list_of_possible_spaces.each{|list| list.each{ |pair| count_arr[index][pair[1]] = count_arr[index][pair[1]].to_i + 1 }}}
possible_spaces = count_arr.map{|count_hash| count_hash.select{|key,val| val > space_threshold }}
possible_spaces.each_with_index.map{|hash,index| hash.map{|key,val| encr_key[key] ||= ciphertexts[index][key] ^ space_ascii }}
plaintext = ciphertexts.map{|encr_msg| encr_msg.each_with_index.map{|val,index| val ^ encr_key[index].to_i}.pack("c*")}
puts "recovered text:\n"
p plaintext[message]
puts "recovered code:\n"
p plaintext[40]
correct_plaintext2 = File.open("2.txt").read.unpack("c*")
final_key2  = ciphertexts[message].zip(correct_plaintext2 ).map{|elem| elem[0] ^ elem[1]}
recovered =  ciphertexts.map{|encr| encr.zip(final_key2)}.map{|encr| encr.map{|pair| pair.first ^ pair.last}}.map{|encr| encr.pack("c*")}
puts "code from plaintext:\n"
p recovered[40]