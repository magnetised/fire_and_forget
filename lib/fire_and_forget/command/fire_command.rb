
require 'daemons'

module FireAndForget
  module Command
    class FireCommand < CommandBase
      attr_reader :niceness

      def niceness
        @task.niceness
      end

      def cmd
        %(#{@task.binary} #{FAF.to_arguments(@params)})
      end

      def run
        puts cmd
        pid = fork do
          Daemons.daemonize(:backtrace => true)
          Process.setpriority(Process::PRIO_PROCESS, 0, niceness) if niceness > 0
          exec(cmd)
        end
        Process.detach(pid) if pid
        FAF::Server.set_pid(@task, pid)
        pid
      end
    end
  end
end
