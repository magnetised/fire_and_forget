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

    should "merge default params and task params" do
      FAF.add_task(:publish, "/path/to/binary", {:param2 => "notvalue2", :param3 => "value3" })

      args = {:param1 => "value1", :param2 => "value2"}
      # mock(FAF::Client).new(:publish, {:param1 => "value1", :param2 => "value2", :param3 => "value3" })
      # FAF.fire(:publish, args)
    end
  end

  context "tasks" do
    should "merge task params and calling params" do
      task = FAF::Task.new(:publish, "/usr/bin", {:param1 => "value1", :param2 => "value2"})
      task.command({"param2" => "newvalue2", :param3 => "value3"}).should == %(launch||/usr/bin --param1="value1" --param2="newvalue2" --param3="value3")
    end
  end

  context "client" do
    should "send right command to server" do
      FAF.add_task(:publish, "/publish", {:param1 => "value1", :param2 => "value2"})
      connection = Object.new
      mock(connection).send(%(launch||/publish --param1="value1" --param2="value3"), 0)
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
end
