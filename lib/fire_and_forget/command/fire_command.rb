
require 'daemons'

module FireAndForget
  module Command
    class FireCommand < CommandBase
      attr_reader :niceness

      def niceness
        @task.niceness
      end

      # def serialize
        # %(fire||#{tag}||#{niceness}||#{binary} #{FAF.to_arguments(merge_params(params))})
      # end

      def cmd
        %(#{@task.binary} #{FAF.to_arguments(@params)})
      end

      def run(params={})
        pid = fork do
          Daemons.daemonize
          system("renice +#{niceness} #{$$}") if niceness > 0
          exec(command)
        end
        Process.detach(pid) if pid
        pid
      end
    end
  end
end
