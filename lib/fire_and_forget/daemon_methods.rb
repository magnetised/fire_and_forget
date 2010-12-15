module FireAndForget
  module DaemonMethods # need better name!

    def self.[](task_name)
      m = Module.new do
        def self.included(klass)
          FAF.map_pid(self.task_name, $$)
        end

        def self.task_name=(task_name)
          @@task_name = task_name
        end

        def self.task_name
          @@task_name
        end

        def set_status(status)
          FAF.set_status(@@task_name, status)
        end
      end
      m.task_name = task_name
      m
    end

  end
end
