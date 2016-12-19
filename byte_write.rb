require 'byebug'
require 'fileutils'

file_name = 'test.bin'
FileUtils.touch file_name
File.truncate file_name, 0

byte = 0x00
offset = 0
write_count = 440

file = File.open file_name, mode: 'r+b'
next_byte = -> {
  byte = (byte + 0x01) % 0x100
}

while offset < write_count
  file.pos = offset
  le_byte = next_byte[]
  puts "Writing #{le_byte.to_s(16)}"
  file.write Array(le_byte).pack('C*')
  file.pos = 0
  length = file.read.length
  offset += 1
  if (offset <=> length) != 0
    puts "offset is #{offset}, file is #{length}"
  end
end

file.close

file = File.open file_name, mode: 'rb'
puts "file was #{file.read.length} bytes, attempted to write #{write_count} bytes"
