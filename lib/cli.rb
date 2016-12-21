require_relative 'cli/decrypt'
require_relative 'cli/key_recovery'

module CLI
  class Runner
    def self.exec
      new.exec
    end

    def exec
      pull_slop
      validate_command_state
      defer
    end

    def help_banner
      <<~USAGE
      Usage:
        #{$0} --derive-key -k keyfile.bin original_file crypted_file
        #{$0} --decrypt    -k keyfile.bin crypted_file [crypted_file [...]]
      USAGE
    end

    def pull_slop
      @opts = Slop.parse suppress_errors: true, banner: help_banner do |o|
        o.bool '--derive-key', 'derive a keyfile from a reference file and a crypted file'
        o.bool '--decrypt',    'decript a file given a key'
        o.string '-k', '--key', 'path to a key file'
        o.on '-h', '--help', 'print this help and exit' do
          puts o
          exit 1
        end
      end
    end

    def validate_command_state
      if @opts.derive_key? && @opts.decrypt?
        puts 'Cannot derive key and decrypt at the same time, specify only one action'
        exit 1
      end

      unless @opts.derive_key? || @opts.decrypt?
        puts 'Specify action as either --derive-key or --decrypt'
        exit 1
      end
    end

    def defer
      if @opts.derive_key?
        CLI::KeyRecovery.new(@opts).exec
      elsif @opts.decrypt?
        CLI::Decrypt.new(@opts).exec
      end

    rescue CLI::PrintHelp
      help_and_exit
    end

    def help_and_exit
      puts
      puts @opts
      exit 1
    end

  end
end
