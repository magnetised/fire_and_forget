module FireAndForget
  module Launcher
    # Registers a task and makes it available for easy launching using #fire
    #
    # @param [Symbol] task_name
    #   the name for the task. This should be unique
    #
    # @param [String] path_to_binary
    #   the path to the executable that should be run when this task is launched
    #
    # @param [Fixnum] niceness
    #   the niceness value of the process >= 0. The higher this value the 'nicer' the launched
    #   process will be (a high nice value results in a low priority task).
    #   On UNIX systems the max, nicest, value is 20
    #
    # @param [Hash] default_params
    #   A Hash of parameters that should be passed to every invocation of the task.
    #   These will be converted to command line parameters
    #     { "setting" => "value", "output" => "destination"}
    #   gives the parameters
    #     --setting=value --output=destination
    #   @see FireAndForget::Utilities#to_arguments
    #
    # @param [Hash] env
    #   A Hash of values to add to the task's ENV settings
    #
    def add_task(task_name, path_to_binary, niceness=0, default_params={}, env={})
      tasks[task_name] = TaskDescription.new(task_name, path_to_binary, niceness, default_params, env)
    end

    # Returns the path to the binary for the given task
    #
    # @param [Symbol] task_name the name of the task
    # @return [String] the path of the task's binary
    def binary(task_name)
      tasks[task_name].binary
    end

    # Gets the TaskDescription of a task
    #
    # @param [Symbol] task_name the name of the task to get
    def [](task_name)
      tasks[task_name]
    end

    def tasks
      @tasks ||= {}
    end

    # Launches the given task
    #
    # @param [Symbol] task_name the name of the task to launch
    # @param [Hash] params parameters to pass to the executable
    def fire(task_name, params={})
      task = tasks[task_name]
      command = Command::Fire.new(task, params)
      Client.run(command)
    end

    # Sets the status of the given task enabling simple interprocess communication through string messages
    #
    # @param [String] task_name the name of the task to set the status for
    # @param [#to_s] status the setting for the given task's status
    def set_status(task_name, status)
      command = Command::SetStatus.new(task_name, status)
      Client.run(command)
    end

    # Get the status for the given task
    # @see #set_status
    #
    # @param [Symbol] task_name the name of the task
    # @return [String] the current status of the task
    def get_status(task_name)
      command = Command::GetStatus.new(task_name)
      Client.run(command)
    end

    # Used by the {FireAndForget::Daemon} module to set the correct PID for a given task
    def map_pid(task_name, pid)
      command = Command::SetPid.new(task_name, pid)
      Client.run(command)
    end
    alias_method :set_pid, :map_pid

    # Retrieve the PID of the running task given by task_name
    def get_pid(task_name)
      command = Command::GetPid.new(task_name)
      Client.run(command)
    end
    alias_method :pid, :get_pid

    # Sends a running task the TERM signal
    def term(task_name)
      kill(task_name, "TERM")
    end

    # Sends a running task the INT signal
    def int(task_name)
      kill(task_name, "INT")
    end

    # Sends a running task an arbitrary signal
    #
    # @param [Symbol] task_name the name of the task to send the signal
    # @param [String] signal the signal to send
    #
    # @see Signal#list for a full list of signals available
    def kill(task_name, signal="TERM")
      command = Command::Kill.new(task_name, signal)
      Client.run(command)
    end

    protected

    # Catch method missing to enable launching of tasks by direct name
    # e.g.
    #   FireAndForget.add_task(:process_things, "/usr/bin/process")
    # launch this task:
    #   FireAndForget.process_things
    #
    def method_missing(method, *args, &block)
      if tasks.key?(method)
        fire(method, *args, &block)
      else
        super
      end
    end
  end
end
