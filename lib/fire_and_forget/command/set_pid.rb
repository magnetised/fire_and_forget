module FireAndForget
  module Command
    class SetPid < CommandBase

      def initialize(task, pid)
        @task_name, @pid = task.name.to_sym, pid.to_i
      end

      def run
        puts "setting pid of #{@task_name} to #{@pid}"
        FAF::Server.pids[@task_name] = @pid
      end
    end
  end
end



