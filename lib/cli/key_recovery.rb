require_relative 'command'
require_relative '../key_recovery'

module CLI
  class KeyRecovery < Command
    def validate_configuration
      opt_must_specify :key, 'keyfile'
      must_have_arguments 2

      @crypted, @reference = @opts.arguments

      path_must_exist @crypted
      path_must_exist @reference

      warn_if_exists  @opts[:key]
    end

    def run_command
      puts "Recovering key..."

      ::KeyRecovery.new(
        reference: @reference,
        crypted: @crypted,
        key_file: @opts[:key]
      ).recover

      puts
      puts "Key file is #{File.size(@opts[:key])} bytes long and contains #{nul_count} NUL bytes."
    end

    def nul_count
      nul_count = 0
      File.open(@opts[:key], 'rb').each_byte do |byte|
        if byte == 0x00
          nul_count += 1
        end
      end

      nul_count
    end

  end
end
