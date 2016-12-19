require 'byebug'

class KeyRecovery
  KEY_LENGTH = 1024

  def unpack word
    word.unpack(@pack_method).first
  end

  def pack word
    Array(word).pack(@pack_method)
  end

  def hex2bin word
    word.to_i(16).to_s(2)
  end

  def bin2hex word
    word.to_i(2).to_s(16)
  end

  def initialize reference_file, crypted_file, key_file
    @reference_file = File.open reference_file, 'r+b'
    @crypted_file   = File.open crypted_file,   'r+b'
    File.truncate key_file, 0
    @key_file       = File.open key_file,       'r+b'
    @pack_method = 'C1'
  end

  def deinit
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

KeyRecovery.new(reference_filename, crypted_filename, key_filename).go


puts "good luck"


