# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fire_and_forget}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Garry Hill"]
  s.date = %q{2010-12-15}
  s.default_executable = %q{fire_forget}
  s.description = %q{Fire & Forget is a simple, framework agnostic, background task launcher for Ruby web apps}
  s.email = %q{garry@magnetised.info}
  s.executables = ["fire_forget"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/fire_forget",
    "examples/long_task",
    "fire_and_forget.gemspec",
    "lib/fire_and_forget.rb",
    "lib/fire_and_forget/client.rb",
    "lib/fire_and_forget/command.rb",
    "lib/fire_and_forget/command/fire.rb",
    "lib/fire_and_forget/command/get_status.rb",
    "lib/fire_and_forget/command/kill.rb",
    "lib/fire_and_forget/command/set_pid.rb",
    "lib/fire_and_forget/command/set_status.rb",
    "lib/fire_and_forget/config.rb",
    "lib/fire_and_forget/daemon.rb",
    "lib/fire_and_forget/launcher.rb",
    "lib/fire_and_forget/server.rb",
    "lib/fire_and_forget/task.rb",
    "lib/fire_and_forget/utilities.rb",
    "lib/fire_and_forget/version.rb",
    "test/helper.rb",
    "test/test_fire_and_forget.rb"
  ]
  s.homepage = %q{http://github.com/magnetised/fire_and_forget}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Fire & Forget is a simple, framework agnostic, background task launcher for Ruby web apps}
  s.test_files = [
    "test/helper.rb",
    "test/test_fire_and_forget.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, ["~> 1.4.6"])
      s.add_runtime_dependency(%q<daemons>, ["~> 1.1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_development_dependency(%q<rr>, ["~> 1.0.2"])
    else
      s.add_dependency(%q<json>, ["~> 1.4.6"])
      s.add_dependency(%q<daemons>, ["~> 1.1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
      s.add_dependency(%q<rr>, ["~> 1.0.2"])
    end
  else
    s.add_dependency(%q<json>, ["~> 1.4.6"])
    s.add_dependency(%q<daemons>, ["~> 1.1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<jnunemaker-matchy>, ["~> 0.4"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.1"])
    s.add_dependency(%q<rr>, ["~> 1.0.2"])
  end
end

