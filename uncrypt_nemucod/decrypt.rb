require 'fileutils'
require_relative 'shared'

module UncryptNemucod
  class Decrypt
    include Shared

    def initialize(crypted_file:, key_file:)
      decrypted_file = crypted_file.gsub(/.crypted$/,'')
      FileUtils.cp crypted_file, decrypted_file

      @decrypted_file = File.open decrypted_file, 'r+b'
      @crypted_file   = File.open crypted_file,   'rb'
      @key_file       = File.open key_file,       'rb'
    end

    def decrypt
      offset = 0
      while offset < KEY_LENGTH && offset < @crypted_file.size
        @key_file.pos = offset
        @crypted_file.pos = offset
        @decrypted_file.pos = offset

        key_byte     = @key_file.read 1
        crypted_byte = @crypted_file.read 1
        decrypt_byte = pack( unpack(key_byte) ^ unpack(crypted_byte) )

        @decrypted_file.write decrypt_byte

        offset += 1
      end

      @crypted_file.close
      @key_file.close
    end
  end
end
