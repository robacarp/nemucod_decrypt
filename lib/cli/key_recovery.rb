require_relative 'command'
require_relative '../key_recovery'

module CLI
  class KeyRecovery < Command
    def validate_configuration
      opt_must_specify :key, 'keyfile'
      opt_must_specify :crypted, 'encrypted file'
      opt_must_specify :reference, 'reference file'

      path_must_exist @opts[:crypted]
      path_must_exist @opts[:reference]

      warn_if_exists  @opts[:key]
    end



    def run_command
      puts "Recovering key..."
      print "\0337" # store cursor position

      ::KeyRecovery.new(
        reference_file: @opts[:reference],
        crypted_file: @opts[:crypted],
        key_file: @opts[:key]
      ).recover do |byte, offset|
        print "\0338" # restore cursor position
        print "\033[K" # clear line from cursor
        print "writing byte #{byte.unpack('H*').first} at offset #{offset}"
      end

      puts
      puts "file is #{File.size(@opts[:key])} bytes long"
      puts "good luck"
    end

  end
end
