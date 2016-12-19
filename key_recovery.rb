require 'byebug'
require_relative 'shared'

class KeyRecovery
  include Shared

  def initialize reference_file, crypted_file, key_file
    @reference_file = File.open reference_file, 'r+b'
    @crypted_file   = File.open crypted_file,   'r+b'
    File.truncate key_file, 0
    @key_file       = File.open key_file,       'r+b'
  end

  def stop
    @reference_file.close
    @crypted_file.close
    @key_file.close
  end

  def go
    @offset = 0
    while @offset < KEY_LENGTH
      write_keybyte extract(read_byte, read_cryptbyte)
      @offset += 1
    end
    check_length
  end

  def extract byte, crypted_byte
    pack( unpack(byte) ^ unpack(crypted_byte) )
  end

  def check_length
    @key_file.pos = 0
    puts "file is #{@key_file.read.length} bytes long"
  end

  def read_cryptbyte
    @crypted_file.pos = @offset
    @crypted_file.read 1
  end

  def read_byte
    @reference_file.pos = @offset
    @reference_file.read 1
  end

  def write_keybyte byte
    puts "writing byte #{byte.unpack('H*').first} at offset #{@offset}"
    @key_file.pos = @offset
    @key_file.write byte
  end
end

reference_filename = '40_icebreakers_for_small_groups.pdf'
crypted_filename = '40_icebreakers_for_small_groups.pdf.crypted'
key_filename = 'key.bin'

KeyRecovery.new(reference_filename, crypted_filename, key_filename).tap do |keyer|
  keyer.go
  keyer.stop
end

puts "good luck"


