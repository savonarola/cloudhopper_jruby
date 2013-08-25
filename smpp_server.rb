java_import 'com.cloudhopper.smpp.SmppServerConfiguration'
java_import 'com.cloudhopper.smpp.impl.DefaultSmppServer'

require 'smpp_executors'

class SmppServer
  
  def initialize(port, serverHandler)
    configuration = SmppServerConfiguration.new
    configuration.setPort(port)
    configuration.setMaxConnectionSize(10)
    configuration.setNonBlockingSocketsEnabled(true)
    configuration.setDefaultRequestExpiryTimeout(30000)
    configuration.setDefaultWindowMonitorInterval(15000)
    configuration.setDefaultWindowSize(5)
    configuration.setDefaultWindowWaitTimeout(configuration.getDefaultRequestExpiryTimeout)
    configuration.setDefaultSessionCountersEnabled(true)
    configuration.setJmxEnabled(true)

    @executors = SmppExecutors.new
    @serverHandler = serverHandler
    @server = DefaultSmppServer.new(configuration, serverHandler, @executors.executor, @executors.monitor_executor)

    puts "Starting SMPP server..."
    @server.start
    puts "SMPP server started"
  end

  def stop
    puts "Stopping SMPP server..."
    @server.stop
    @server.destroy
    @executors.stop
    puts "SMPP server stopped"
  end

end
