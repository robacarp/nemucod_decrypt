require_relative 'command'
require_relative '../decrypt'

module CLI
  class Decrypt < Command
    def validate_configuration
      opt_must_specify :key, 'keyfile'
      path_must_exist @opts[:key]

      must_have_arguments 1
      debugger
      @files_to_decrypt = @opts.arguments
    end

    def run_command
      @files_to_decrypt.each do |encrypted_path|
        path_must_exist encrypted_path
        if warn_if_exists decrypt_path(encrypted_path), die: false
          decrypt_file encrypted_path
        end
      end
    end

    def decrypt_file encrypted_file
      print "Decrypting #{encrypted_file}..."

      ::Decrypt.new(
        crypted_file: encrypted_file,
        key_file: @opts[:key]
      ).decrypt

      puts "OK"
    end

    private

    def decrypt_path path
      path.gsub(/.crypted$/,'')
    end

  end
end
