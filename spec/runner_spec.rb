require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'jar_wrapper/runner'

describe JarWrapper::Runner do
  describe "#build" do
    before do
      subject.java_opts = ["-Xmx1024m", "-Xss1024k" ]
    end

    it "should install jar file from URL" do
      source = "http://selenium.googlecode.com/files/selenium-server-standalone-2.37.0.jar"
      target = "selenium-server-standalone-2.37.0.jar"

      subject.stub(:download_file_to)
      subject.stub(:unzip_file)

      subject.install source, target
    end

    it "should execute java jar file" do
      subject.jar_file = "selenium-server-standalone.jar"

      subject.stub(:exec).with "java -XstartOnFirstThread -d32 -client -Xmx1024m -Xss1024k -jar selenium-server-standalone.jar #{`pwd`.chomp!}/spec/runner_spec.rb"

      subject.run ARGV
    end

    it "should execute java main class" do
      subject.classpath = "some_class_path"
      subject.main_class = "main_class"

      subject.stub(:exec).with "java -XstartOnFirstThread -d32 -client -Xmx1024m -Xss1024k -cp some_class_path main_class #{`pwd`.chomp!}/spec/runner_spec.rb"

      subject.run ARGV
    end
  end
end
