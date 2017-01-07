require 'slop'

module UncryptNemucod
  module CLI
    class PrintHelp < RuntimeError
    end

    class Command
      def initialize options
        @opts = options
      end

      def exec
        validate_configuration
        run_command
      end

      private

      def opt_must_specify option, description
        if @opts[option].nil?
          puts "No #{description} specified"
          fail PrintHelp
        end
      end

      def path_must_exist path
        unless path_exists? path
          puts "File does not exist: #{path}"
          fail PrintHelp
        end
      end

      def warn_if_exists path, die: true
        return true unless path_exists? path

        puts "File exists: #{path}"
        print "Overwrite? [yN] "
        response = STDIN.gets.chomp.downcase

        if die && response != ?y
          exit 1
        end

        response == ?y
      end

      def must_have_arguments count
        if @opts.arguments.count < count
          puts "You must specify #{count} files"
          fail PrintHelp
        end
      end

      def path_exists? path
        File.exist?(File.absolute_path path)
      end

    end
  end
end
