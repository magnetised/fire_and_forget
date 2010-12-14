require 'helper'

class TestFireAndForget < Test::Unit::TestCase
  context "Utilities" do
    should "translate a hash to command line arguments" do
      FAF.to_arguments({
        :param1 => "value1",
        :param2 => "value2",
        :array => [1, 2, "3"]
      }).should == %(--array=[1,2,"3"] --param1="value1" --param2="value2")
    end
  end
  context "configuration" do
    should "enable mapping of task to a binary" do
      FAF.add_task(:publish, "/path/to/binary")
      FAF.binary(:publish).should ==  "/path/to/binary"
      FAF[:publish].binary.should ==  "/path/to/binary"
    end

    should "enable setting of a niceness value for the task" do
      FAF.add_task(:publish, "/path/to/binary", 10)
      FAF[:publish].niceness.should ==  10
    end

    should "enable launching a task by its name" do
      FAF.add_task(:publish, "/path/to/binary")
      args = {:param1 => "param1", :param2 => "param2"}
      mock(FAF).fire(:publish, args)
      FAF.publish(args)
    end

    should "enable setting of port for server" do
      FAF.port = 3007
      FAF.port.should == 3007
    end

    should "enable setting an address for the server" do
      FAF.bind_address = "10.0.1.10"
      FAF.bind_address.should == "10.0.1.10"
    end
  end

  context "commands" do
    should "serialize and deserialize correctly" do
      task = FAF::Task.new(:publish, "/publish", {:param1 => "value1", :param2 => "value2"}, 9)
      cmd = FAF::Command::CommandBase.new(task, {"param2" => "newvalue2", :param3 => "value3"})
      cmd2 = FAF::Command.load(cmd.dump)
      task2 = cmd2.task
      task2.binary.should == task.binary
      task2.params.should == task.params
      task2.name.should == task.name
      cmd.params.should == {"param1" => "value1", "param2" => "newvalue2", "param3" => "value3"}
    end
  end
  context "actions" do
    setup do
      @task = FAF::Task.new(:publish, "/publish", {:param1 => "value1", :param2 => "value2"}, 9)
    end
    should "set status for a task" do
      cmd = FAF::Command::SetStatus.new(:publish, :doing)
      FAF::Server.run(cmd)
      cmd = FAF::Command::GetStatus.new(:publish)
      status = FAF::Server.run(cmd)
      status.should == :doing
    end
  end

  context "client" do
    should "send right command to server" do
      task = FAF.add_task(:publish, "/publish", {:param1 => "value1", :param2 => "value2"}, 12)
      command = Object.new
      mock(command).dump { "dumpedcommand" }
      mock(FAF::Command::FireCommand).new(task, {:param2 => "value3"}) { command }
      connection = Object.new
      mock(connection).send("dumpedcommand", 0)
      stub(connection).flush
      stub(connection).close_write
      mock(connection).read { "99999" }
      mock(connection).close
      FAF.bind_address = "10.0.1.10"
      FAF.port = 9007
      mock(TCPSocket).open("10.0.1.10", 9007) { connection }
      pid = FAF.publish({:param2 => "value3"})
      pid.should == "99999"
    end
  end

  context "server" do
    setup do
      @server = FAF::Server.new
    end

    should "run any command sent to it" do
      command = Object.new
      mock(FAF::Command).load(is_a(String)) { command }
      mock(command).run { "666" }
      result = FAF::Server.run("object")
      result.should == "666"
    end
  end
end
