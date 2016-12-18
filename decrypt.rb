require 'byebug'
require 'fileutils'

crypted_file = 'DOC082416-08242016125238.pdf.crypted'
crypted_file = 'fruit.pdf.crypted'
key_file = 'key.bin'
KEY_LENGTH = 2048
PACK_METHOD = 'B8'

unpack = -> (word) { word.unpack(PACK_METHOD).first.to_i(2) }
pack   = -> (word) { Array(word.to_s(2)).pack(PACK_METHOD)  }
hex2bin= -> (word) { word.to_i(16).to_s(2) }
bin2hex= -> (word) { word.to_i(2).to_s(16) }

decrypted_file = crypted_file.gsub(/.crypted$/,'')
# FileUtils.cp crypted_file, decrypted_file
FileUtils.touch decrypted_file

offset = 0
while offset < KEY_LENGTH
  key_byte     = File.read key_file,     1, offset, mode: 'rb'
  crypted_byte = File.read crypted_file, 1, offset, mode: 'rb'
  decrypt_byte = pack[ unpack[key_byte] ^ unpack[crypted_byte] ]

  File.write decrypted_file, decrypt_byte, offset, mode: 'r+b'

  offset += 1
end

puts "good luck"

