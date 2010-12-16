module FireAndForget
  module Launcher
    def add_task(task_name, path_to_binary, default_params={}, niceness=0)
      if default_params.is_a?(Numeric)
        niceness = default_params
        default_params = {}
      end
      tasks[task_name] = TaskDescription.new(task_name, path_to_binary, default_params, niceness)
    end

    def binary(task_name)
      tasks[task_name].binary
    end

    def [](task_name)
      tasks[task_name]
    end

    def tasks
      @tasks ||= {}
    end

    def fire(task_name, params={})
      task = tasks[task_name]
      command = Command::Fire.new(task, params)
      Client.run(command)
    end

    def set_status(task_name, status)
      command = Command::SetStatus.new(task_name, status)
      Client.run(command)
    end

    def get_status(task_name)
      command = Command::GetStatus.new(task_name)
      Client.run(command)
    end

    def map_pid(task_name, pid)
      command = Command::SetPid.new(task_name, pid)
      Client.run(command)
    end

    def term(task_name)
      kill(task_name, "TERM")
    end

    def int(task_name)
      kill(task_name, "INT")
    end

    def kill(task_name, signal="TERM")
      command = Command::Kill.new(task_name, signal)
      Client.run(command)
    end

    protected

    def method_missing(method, *args, &block)
      if tasks.key?(method)
        fire(method, *args, &block)
      else
        super
      end
    end
  end
end
