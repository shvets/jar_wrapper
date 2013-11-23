require 'fileutils'
require 'open-uri'
require 'rbconfig'

# some code is extracted from redcar project (https://github.com/redcar/redcar) which is in turn extracted 
# from ruby-processing gem (https://github.com/jashkenas/ruby-processing).

module JarWrapper
  class Runner
    attr_accessor :main_class, :classpath, :jar_file, :java_opts

    def initialize
      windows? ? (require "zip/zipfilesystem") : (require 'zip/zip')
    end

    def install source, destination
      download_file_to(source, destination)

      unzip_file(destination) if destination =~ /\.zip$/
    end

    def run args
      construct_command(args) do |command|
        exec(command.join(" "))
      end
    end

    private

    def windows?
      !!(RbConfig::CONFIG['host_os'] =~ /mswin|mingw|windows/)
    end

    def construct_command(args="")
      command = ["java"]
      command.push(*java_args)
      # command.push("-Xbootclasspath/a:#{jruby_complete}")
      # command.push("-Dfile.encoding=UTF8", "-Xmx320m", "-Xss1024k", "-Djruby.memory.max=320m", "-Djruby.stack.max=1024k", "org.jruby.Main")
      command.push(*java_opts) unless java_opts.nil? or java_opts.length == 0

      command.push("-jar", jar_file) if jar_file
      command.push("-cp", classpath, main_class) if main_class

      #command.push("-Djruby.memory.max=500m", "-Djruby.stack.max=1024k", "-cp", jruby_complete, "org.jruby.Main")

      command.push "--debug" if debug_mode?

      command.push(*cleaned_args(args))

      puts command.join(' ')
      yield command
    end

    def cleaned_args args
      # We should never pass --fork to a subprocess
      result = args.find_all { |arg| arg != '--fork' }.map do |arg|
        if arg =~ /--(.+)=(.+)/
          "--" + $1 + "=\"" + $2 + "\""
        else
          arg
        end
      end
      result.delete("install")
      result
    end

    def debug_mode?
      ARGV.include?("--debug")
    end

    def java_args
      str = []
      if Config::CONFIG["host_os"] =~ /darwin/
        str.push "-XstartOnFirstThread"
      end

      str.push "-d32" if d32?
      str.push "-client" if client?

      str
    end

    def redirect
      @redirect ||= "> #{null_device} 2>&1"
    end

    def d32?
      @d32 ||= system("java -d32 #{redirect}")
    end

    def client?
      @client ||= system("java -client #{redirect}")
    end

    # @return [:osx/:windows/:linux]
    def platform
      case Config::CONFIG["target_os"]
        when /darwin/
          :osx
        when /mswin|mingw/
          :windows
        when /linux/
          :linux
        else
          # type code here
      end
    end

    def null_device
      case platform
        when :windows
          'nul'
        else
          '/dev/null'
      end
    end

    def download_file_to(uri, destination_file)
      print "  downloading #{uri}... "; $stdout.flush

      temp = destination_file + ".part"
      FileUtils.mkdir_p(File.dirname(destination_file))

      File.open(temp, "wb") do |out_file|
        open(uri) do |in_file|
          done = false

          until done do
            buffer = in_file.read(1024*1000)
            out_file.write(buffer)

            if buffer.nil? || buffer.size == 0
              done = true
            else
              print("#"); $stdout.flush
            end
          end
        end
      end

      if File.open(temp).read(200) =~ /Access Denied/
        puts "\n\n*** Error downloading #{uri}, got Access Denied from S3."
        FileUtils.rm_rf(temp)
        exit
      end

      FileUtils.cp(temp, destination_file)
      FileUtils.rm_rf(temp)
      puts "\ndone!"
    end

    # unzip a .zip file into the directory it is located
    def unzip_file(path)
      print "unzipping #{path}..."; $stdout.flush
      source = File.expand_path(path)
      Dir.chdir(File.dirname(source)) do
        Zip::ZipFile.open(source) do |zipfile|
          zipfile.entries.each do |entry|
            FileUtils.mkdir_p(File.dirname(entry.name))
            begin
              entry.extract
            rescue Zip::ZipDestinationFileExistsError
              # ignored
            end
          end
        end
      end
    end
  end
end


 