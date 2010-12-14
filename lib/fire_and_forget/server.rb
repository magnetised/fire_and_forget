
module FireAndForget
  class Server
    def load(command_string)
      command = Command.load(command_string)
      command.run
    end
  end
end
