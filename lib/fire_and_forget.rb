
module FireAndForget
  DEFAULT_SOCKET = "/tmp/fire_and_forget.sock"
  ENV_SOCKET = "FAF_SOCKET"
  ENV_TASK_NAME = "FAF_TASK_NAME"

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
