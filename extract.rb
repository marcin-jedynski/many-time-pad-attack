file = File.open('084.xor', 'rb')

#p file.bytes.each_slice(256).take(41).combination(2).to_a.length
#puts file.bytes.each_slice(256).take(41).combination(2).map{|slice| slice.transpose.map{|x| x.reduce(){|a,b| a^b }}.pack("c*") }
key_size = 256
possible_space_range_1 = (65..90)
possible_space_range_2 = (97..122)
slices = file.bytes.each_slice(key_size)
ciphertexts = slices.take(41)
count_dic = []

xored = ciphertexts.map{|encr_msg| ciphertexts.map{|other_encr_msg| [other_encr_msg,encr_msg]}.map{|msg_pair| msg_pair.transpose.map{|zipped_chars| zipped_chars.reduce(){|a,b| a^b}}}.select(){|arr| arr.any?{|elem| elem != 0}}}
filtered = xored.map{|xored_msg_list| xored_msg_list.map{|xored_msg| xored_msg.each_with_index.map{|val,index| [val,index]}.select{|element| (possible_space_range_1 === element[0] or possible_space_range_2 === element[0] or element[0] == 0)}}}
filtered.each_with_index.map{|list_of_possible_spaces,index| count_dic[index] = {};list_of_possible_spaces.each{|list| list.each{ |pair| count_dic[index][pair[1]] = count_dic[index][pair[1]].to_i + 1 }}}
possible_spaces = count_dic.map{|count_hash| count_hash.select{|key,val| val > 35 }}
p possible_spaces

