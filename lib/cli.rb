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

    def pull_slop
      @opts = Slop.parse suppress_errors: true do |o|
        o.bool '--derive-key', 'derive a keyfile from a reference file and a crypted file'
        o.bool '--decrypt', 'decript a file given a key'

        o.string '-c', '--crypted', 'path to a crypted file'
        o.string '-r', '--reference', 'path to a reference file'
        o.string '-k', '--key', 'path to a key file'
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
    end

  end
end
