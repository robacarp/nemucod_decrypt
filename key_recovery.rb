require 'byebug'

reference_filename = '40_icebreakers_for_small_groups.pdf'
crypted_filename = '40_icebreakers_for_small_groups.pdf.crypted'
key_filename = 'key.bin'
KEY_LENGTH = 2048
PACK_METHOD = 'B8'

unpack = -> (word) { word.unpack(PACK_METHOD).first.to_i(2) }
pack   = -> (word) { Array(word.to_s(2)).pack(PACK_METHOD)  }
hex2bin= -> (word) { word.to_i(16).to_s(2) }
bin2hex= -> (word) { word.to_i(2).to_s(16) }

File.truncate key_filename, 0
key_file = File.open key_filename, mode: 'r+b'
reference_file = File.open reference_filename, mode: 'rb'
crypted_file = File.open crypted_filename, mode: 'rb'

offset = 0
while offset < KEY_LENGTH
  reference_file.pos = offset
  crypted_file.pos = offset

  byte         = reference_file.read 1
  crypted_byte = crypted_file.read 1

  key_byte     = pack[ unpack[byte] ^ unpack[crypted_byte] ]

  print "writing byte #{unpack[key_byte].to_s(16)} at offset #{offset}; "
  key_file.pos = offset
  key_file.write key_byte

  key_file.pos = 0
  puts "file is #{key_file.read.length} bytes long"
  # File.write key_filename, key_byte, offset, mode: 'r+b'

  offset += 1
end

key_file.close

puts "good luck"


