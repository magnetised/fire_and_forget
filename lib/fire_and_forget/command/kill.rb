module FireAndForget
  module Command
    class Kill < CommandBase

      def initialize(task_name, signal="TERM")
        @task_name, @signal = task_name.to_sym, signal
      end

      def run
        FAF::Server.kill(@task_name, @signal)
      end
    end
  end
end



