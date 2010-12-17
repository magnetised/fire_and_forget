
module FireAndForget
  DEFAULT_PORT = 3001

  autoload :Config, "fire_and_forget/config"
  autoload :Utilities, "fire_and_forget/utilities"
  autoload :Launcher, "fire_and_forget/launcher"
  autoload :TaskDescription, "fire_and_forget/task_description"
  autoload :Client, "fire_and_forget/client"
  autoload :Command, "fire_and_forget/command"
  autoload :Server, "fire_and_forget/server"
  autoload :Daemon, "fire_and_forget/daemon"

  require "fire_and_forget/errors"

  extend Config
  extend Utilities
  extend Launcher
end

FAF = FireAndForget unless defined?(FAF)
