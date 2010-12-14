module FireAndForget
  module Command
    class SetStatus < CommandBase

      def initialize(task_name, status_value)
        @task_name, @status_value = task_name.to_sym, status_value
      end

      def run
        FAF::Server.status[@task_name] = @status_value
      end
    end
  end
end

