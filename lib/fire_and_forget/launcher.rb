module FireAndForget
  module Launcher
    def add_task(task_name, path_to_binary, default_params={})
      tasks[task_name] = Task.new(task_name, path_to_binary, default_params)
    end

    def binary(task_name)
      tasks[task_name].binary
    end

    def tasks
      @tasks ||= {}
    end

    def fire(task_name, params={})
      task = tasks[task_name]
      client = Client.new(task, params)
      client.fire
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
