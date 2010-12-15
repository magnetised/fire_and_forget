
module FireAndForget
  class Server
    def self.parse(command_string)
      command = Command.load(command_string)
      run(command)
    end

    def self.run(cmd)
      cmd.run
    end

    def self.status
      @status ||= {}
    end

    def self.set_pid(task_name, pid)
      pids[task_name] = pid.to_i
    end

    def self.get_pid(task)
      pids[task.name]
    end

    def self.pids
      @pids ||= {}
    end
  end
end
