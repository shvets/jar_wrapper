# Rakefile for winstone

task :default => :gemspec

begin
  require 'bundler'
  
  begin
    require 'jeweler'
    
    Jeweler::Tasks.new do |gemspec|
      gemspec.name = "jar_wrapper"
      gemspec.summary = "Jar wrapper for executable java jar (Summary)."
      gemspec.description = "Jar wrapper for executable java jar."
      gemspec.email = "alexander.shvets@gmail.com"
      gemspec.homepage = "http://github.com/shvets/jar_wrapper"
      gemspec.authors = ["Alexander Shvets"]
      gemspec.files = FileList["CHANGES", "jar_wrapper.gemspec", "Rakefile", "README", "VERSION",
                               "lib/**/*", "bin/**/*"] 
      gemspec.requirements = ["none"]
      gemspec.bindir = "bin"
    
      gemspec.add_bundler_dependencies
    end
  rescue LoadError
    puts "Jeweler not available. Install it s with: [sudo] gem install jeweler"
  end
rescue LoadError
  puts "Bundler not available. Install it s with: [sudo] gem install bundler"
end


desc "Release the gem"
task :"release:gem" do
  %x(
      rake gemspec
      rake build
      rake install
      git add .  
  )  
  puts "Commit message:"  
  message = STDIN.gets

  version = "#{File.open(File::dirname(__FILE__) + "/VERSION").readlines().first}"

  %x(
    git commit -m "#{message}"
    
    git push origin master

    gem push pkg/jar_wrapper-#{version}.gem      
  )
end

