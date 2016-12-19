require 'byebug'
require 'fileutils'
require_relative 'shared'

class Decrypt
  include Shared

  def initialize crypted_filepath, key_filepath
    decrypted_filepath = crypted_filepath.gsub(/.crypted$/,'')
    FileUtils.cp crypted_filepath, decrypted_filepath
    # FileUtils.touch decrypted_filepath
    # File.truncate decrypted_filepath, 0

    @decrypted_file = File.open decrypted_filepath, 'r+b'
    @crypted_file   = File.open crypted_filepath,   'r+b'
    @key_file       = File.open key_filepath,       'r+b'
  end

  def go
    offset = 0
    while offset < KEY_LENGTH
      @key_file.pos = offset
      @crypted_file.pos = offset
      @decrypted_file.pos = offset

      key_byte     = @key_file.read 1
      crypted_byte = @crypted_file.read 1
      decrypt_byte = pack( unpack(key_byte) ^ unpack(crypted_byte) )

      @decrypted_file.write decrypt_byte

      offset += 1
    end
  end

  def stop
    @crypted_file.close
    @key_file.close
  end
end

crypted_file = 'DOC082416-08242016125238.pdf.crypted'
crypted_file = 'fruit.pdf.crypted'
key_file = 'key.bin'

Decrypt.new(crypted_file, key_file).tap do |keyer|
  keyer.go
  keyer.stop
end

puts "good luck"

