require 'jruby_deps'

require 'default_smpp_server_handler'
require 'smpp_server'
require 'user_interaction/deliver_loop'

if ARGV.size < 1
  puts "Usage: #{$0} PORT [ussd]\n"
  exit(1)
end

port = ARGV[0].to_i
ussd = ARGV[1]

serverHandler = DefaultSmppServerHandler.new
server = SmppServer.new(port, serverHandler)

deliver_loop = UserInteraction::DeliverLoop.new(serverHandler, ussd)
deliver_loop.run

server.stop




