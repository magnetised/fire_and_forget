
module FireAndForget
  DEFAULT_PORT = 3001

  autoload :Config, "fire_and_forget/config"
  autoload :Utilities, "fire_and_forget/utilities"
  autoload :Launcher, "fire_and_forget/launcher"
  autoload :Task, "fire_and_forget/task"
  autoload :Client, "fire_and_forget/client"
  autoload :Command, "fire_and_forget/command"
  autoload :Server, "fire_and_forget/server"
  autoload :Daemon, "fire_and_forget/daemon"

  extend Config
  extend Utilities
  extend Launcher
end

FAF = FireAndForget unlesss defined?(FAF)
