require 'slop'

class CLI
  def go
    pull_slop
    validate_command_state
    validate_configuration
    run_command
  end

  private

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

  def validate_configuration
    case
    when @opts.derive_key?
      path_must_exist! @opts[:crypted]
      path_must_exist! @opts[:reference]

      if @opts[:key].nil?
        puts 'No keyfile specified'
        exit 1
      end

      warn_if_exists!  @opts[:key]
    when @opts.decrypt?
      path_must_exist! @opts[:key]
      path_must_exist! @opts[:crypted]
      warn_if_exists! decrypt_path @opts[:crypted]
    end
  end

  def path_must_exist! path
    unless path_exists? path
      puts "File does not exist: #{path}"
      exit 1
    end
  end

  def warn_if_exists! path
    if path_exists? path
      puts "File exists: #{path}"
      puts "Overwrite? [yN] "
      exit 1
    end
  end

  def path_exists? path
    File.exist?(File.absolute_path path)
  end

  def decrypt_path path
    path.gsub(/.crypted$/,'')
  end

  def run_command
    puts "Running command!"
  end
end
