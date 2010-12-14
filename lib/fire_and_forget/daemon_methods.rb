module FireAndForget
  module DaemonMethods # need better name!
    def set_status(task_name, status)
      FAF.set_status(task_name, status)
    end
  end
end
