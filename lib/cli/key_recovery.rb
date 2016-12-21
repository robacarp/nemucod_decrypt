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
        file1: @reference,
        file2: @crypted,
        key_file: @opts[:key]
      ).recover

      puts
      # TODO count nils in key file?
      puts "key file is #{File.size(@opts[:key])} bytes long."
    end

  end
end
