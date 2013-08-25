require 'jruby_deps'

require 'server_handler'
require 'smpp_server'
require 'user_interaction/deliver_loop'

if ARGV.size < 1
  puts "Usage: #{$0} PORT [ussd]\n"
  exit(1)
end

port = ARGV[0].to_i
ussd = ARGV[1]

serverHandler = ServerHandler.new
server = SmppServer.new(port, serverHandler)

deliver_loop = UserInteraction::DeliverLoop.new(serverHandler, ussd)
deliver_loop.run

server.stop




