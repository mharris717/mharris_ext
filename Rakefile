require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "mharris_ext"
    s.summary = %Q{mharris717 utility methods}
    s.email = "mharris717@gmail.com"
    s.homepage = "http://github.com/GFunk911/mharris_ext"
    s.description = "mharris717 utlity methods"
    s.authors = ["Mike Harris"]
    s.add_dependency 'fattr'
    s.add_dependency 'facets'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end



require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

task :default => :test

Jeweler::GemcutterTasks.new

