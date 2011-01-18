module FireAndForget
  module Command
    class SetPid < CommandBase

      attr_reader :task_name, :pid

      def initialize(task_name, pid)
        @task_name, @pid = task_name.to_sym, pid.to_i
      end

      def run
        FireAndForget::Server.pids[@task_name] = @pid
      end
    end
  end
end

