require 'slop'

module CLI
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
        exit 1
      end
    end

    def path_must_exist path
      unless path_exists? path
        puts "File does not exist: #{path}"
        exit 1
      end
    end

    def warn_if_exists path
      if path_exists? path
        puts "File exists: #{path}"
        puts "Overwrite? [yN] "
        exit 1
      end
    end

    def path_exists? path
      File.exist?(File.absolute_path path)
    end

  end
end
