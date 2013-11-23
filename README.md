# Jar Wrapper - wrapper for executable java jar files

## Installing Jar Wrapper

    $ gem install jar_wrapper

## Usage

```ruby
require 'jar_wrapper'

wrapper = JarWrapper::Runner.new
wrapper.java_opts = ["-Xmx1024m", "-Xss1024k" ]

# install jar file from source URL into target file:

wrapper.install source, target

# execute jar file (java -jar jar_file.jar):

wrapper.jar_file = "jar_file.jar"
wrapper.run

# execute main class (java -cp some_class_path main_class):

wrapper.classpath = "some_class_path"
wrapper.main_class = "main_class"
wrapper.run
```

      
