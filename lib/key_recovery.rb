require_relative 'shared'
require 'fileutils'

class KeyRecovery
  include Shared

  def initialize(reference_file:, crypted_file:, key_file:)
    FileUtils.touch key_file
    File.truncate key_file, 0
    @key_file       = File.open key_file,       'r+b'
    @reference_file = File.open reference_file, 'r+b'
    @crypted_file   = File.open crypted_file,   'r+b'
  end

  def recover
    @offset = 0
    while @offset < KEY_LENGTH
      byte = extract(read_byte, read_cryptbyte)
      @key_file.pos = @offset
      @key_file.write byte

      if block_given?
        yield byte, @offset
      end

      @offset += 1
    end
  end

  def close_files
    @reference_file.close
    @crypted_file.close
    @key_file.close
  end

  def extract byte, crypted_byte
    pack( unpack(byte) ^ unpack(crypted_byte) )
  end

  def read_cryptbyte
    @crypted_file.pos = @offset
    @crypted_file.read 1
  end

  def read_byte
    @reference_file.pos = @offset
    @reference_file.read 1
  end
end

