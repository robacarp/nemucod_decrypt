require_relative 'command'

module CLI
  class Decrypt < Command
    def validate_configuration
      opt_must_specify :key, 'keyfile'
      opt_must_specify :crypted, 'encrypted file'

      path_must_exist @opts[:key]
      path_must_exist @opts[:crypted]

      warn_if_exists decrypt_path @opts[:crypted]
    end

    def run_command
      puts "Would decrypt file"
    end

    private

    def decrypt_path path
      path.gsub(/.crypted$/,'')
    end

  end
end
