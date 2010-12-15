
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

      def permitted?
        File.exists?(@task.binary) && File.owned?(@task.binary)
      end

      def run
        if permitted?
          puts cmd
          pid = fork do
            Daemons.daemonize(:backtrace => true)
            Process.setpriority(Process::PRIO_PROCESS, 0, niceness) if niceness > 0
            exec(cmd)
          end
          Process.detach(pid) if pid
          FAF::Server.set_pid(@task, pid)
          pid
        else
          raise Errno::EACCES
        end
      end
    end
  end
end
