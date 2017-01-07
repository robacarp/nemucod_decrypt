require_relative 'cli/decrypt'
require_relative 'cli/key_recovery'

require_relative 'version'

module UncryptNemucod
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
        Uncrypt Nemucod, a small utility gem to derive and decode files "encrypted" by the Nemucod ransomware.

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

          o.on '-v', '--version', 'print version and exit' do
            puts "#{$0} Version #{UncryptNemucod::VERSION}"
            exit
          end

          o.on '-h', '--help', 'print this help and exit' do
            puts o
            exit
          end
        end
      end

      def validate_command_state
        if @opts.derive_key? && @opts.decrypt?
          puts 'Cannot derive key and decrypt at the same time, specify only one action'
          help_and_exit
        end

        unless @opts.derive_key? || @opts.decrypt?
          puts 'Specify action as either --derive-key or --decrypt'
          help_and_exit
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
end
