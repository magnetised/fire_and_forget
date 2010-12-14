module FireAndForget
  module Launcher
    def add_task(task_name, path_to_binary, default_params={}, niceness=0)
      if default_params.is_a?(Numeric)
        niceness = default_params
        default_params = {}
      end
      tasks[task_name] = Task.new(task_name, path_to_binary, default_params, niceness)
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
      run_command(task_name, Command::FireCommand, params)
    end

    protected

    def run_command(task_name, command_class, params)
      task = tasks[task_name]
      command = command_class.new(task, params)
      Client.run(command)
    end

    def method_missing(method, *args, &block)
      if tasks.key?(method)
        fire(method, *args, &block)
      else
        super
      end
    end
  end
end
