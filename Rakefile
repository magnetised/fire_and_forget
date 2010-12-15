require 'rubygems'
# require 'bundler'
# begin
#   Bundler.setup(:default, :development)
# rescue Bundler::BundlerError => e
#   $stderr.puts e.message
#   $stderr.puts "Run `bundle install` to install missing gems"
#   exit e.status_code
# end
require 'rake'
require 'jeweler'

require 'lib/fire_and_forget/version'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "fire_and_forget"
  gem.homepage = "http://github.com/magnetised/fire_and_forget"
  gem.license = "MIT"
  gem.summary = %Q{Fire & Forget is a simple, framework agnostic, background task launcher for Ruby web apps}
  gem.description = %Q{Fire & Forget is a simple, framework agnostic, background task launcher for Ruby web apps}
  gem.email = "garry@magnetised.info"
  gem.authors = ["Garry Hill"]
  gem.version = FireAndForget::VERSION

  gem.add_runtime_dependency "json", "~>1.4.6"
  gem.add_runtime_dependency "daemons", "~>1.1.0"

  gem.add_development_dependency "shoulda", ">= 0"
  gem.add_development_dependency 'jnunemaker-matchy', '~>0.4'
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.5.1"
  gem.add_development_dependency "rr", "~>1.0.2"
end

Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "fire_and_forget #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
