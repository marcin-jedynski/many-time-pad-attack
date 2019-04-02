file = File.open('084.xor', 'rb')

#p file.bytes.each_slice(256).take(41).combination(2).to_a.length
#puts file.bytes.each_slice(256).take(41).combination(2).map{|slice| slice.transpose.map{|x| x.reduce(){|a,b| a^b }}.pack("c*") }

slices = file.bytes.each_slice(256).take(41)
possible_space_range_1 = (65..90)
possible_space_range_2 = (97..122)
chosen  = slices.pop

pairs = slices.map{|x| [x,chosen]}

xored = pairs.map{|slice| slice.transpose.map{|x| x.reduce(){|a,b| a^b }} }
filtered = xored.map{|x| x.each_with_index.map{|val,index| [val,index]}.select{|element| (possible_space_range_1 === element[0] or possible_space_range_2 === element[0] or element[0] == 0)}}

#prints possible candidates for spaces for first chunk of message
filtered.each{|elem| p elem}
