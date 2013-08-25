require 'jruby_deps'

java_import 'com.cloudhopper.smpp.SmppServerConfiguration'
java_import 'com.cloudhopper.smpp.impl.DefaultSmppServer'

require 'smpp_executors'
require 'default_smpp_server_handler'

executors = SmppExecutors.new

configuration = SmppServerConfiguration.new
configuration.setPort(2776)
configuration.setMaxConnectionSize(10)
configuration.setNonBlockingSocketsEnabled(true)
configuration.setDefaultRequestExpiryTimeout(30000)
configuration.setDefaultWindowMonitorInterval(15000)
configuration.setDefaultWindowSize(5)
configuration.setDefaultWindowWaitTimeout(configuration.getDefaultRequestExpiryTimeout)
configuration.setDefaultSessionCountersEnabled(true)
configuration.setJmxEnabled(true)

smppServer = DefaultSmppServer.new(configuration, DefaultSmppServerHandler.new, executors.executor, executors.monitor_executor)

puts "Starting SMPP server..."
smppServer.start
puts "SMPP server started"

puts "Press enter to stop server"
gets

puts "Stopping SMPP server..."
smppServer.stop
executors.stop
puts "SMPP server stopped"


