module FireAndForget
  module Daemon # need better name!

    def self.[](task_name)
      m = Module.new do
        def self.included(klass)
          FireAndForget.map_pid(self.task_name, $$)
        end

        def self.task_name=(task_name)
          @@task_name = task_name
        end

        def self.task_name
          @@task_name
        end

        def set_task_status(status)
          FireAndForget.set_status(@@task_name, status)
        end
      end
      m.task_name = task_name
      m
    end

  end
end
