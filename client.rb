require 'jruby_deps'

java_import 'com.cloudhopper.commons.charset.CharsetUtil'
java_import 'com.cloudhopper.smpp.SmppSessionConfiguration'
java_import 'com.cloudhopper.smpp.SmppBindType'
java_import 'com.cloudhopper.smpp.SmppSession'
java_import 'com.cloudhopper.smpp.impl.DefaultSmppClient'
java_import 'com.cloudhopper.smpp.type.Address'
java_import 'com.cloudhopper.smpp.pdu.EnquireLink'
java_import 'com.cloudhopper.smpp.pdu.SubmitSm'

require 'smpp_executors'
require 'client_smpp_session_handler'

executors = SmppExecutors.new

clientBootstrap = DefaultSmppClient.new(executors.executor, 1, executors.monitor_executor)
sessionHandler = ClientSmppSessionHandler.new

config = SmppSessionConfiguration.new
config.setWindowSize(1)
config.setName("Tester.Session.0")
config.setType(SmppBindType::TRANSCEIVER)
config.setHost("127.0.0.1")
config.setPort(2776)
config.setConnectTimeout(10000)
config.setSystemId("1234567890")
config.setPassword("password")
config.getLoggingOptions.setLogBytes(true)
config.setRequestExpiryTimeout(30000)
config.setWindowMonitorInterval(15000)
config.setCountersEnabled(true)

session = clientBootstrap.bind(config, sessionHandler)
            
puts "Press enter to send sync enquireLink #1"
gets

enquireLinkResp1 = session.enquireLink(EnquireLink.new, 10000)

puts "Press enter to send async enquireLink #2"
gets

session.sendRequestPdu(EnquireLink.new, 10000, false)

puts "Press enter to send async submit_sm"
gets

text = "Lorem [ipsum] dolor sit amet, consectetur adipiscing elit. Proin feugiat, leo id commodo tincidunt, nibh diam ornare est, vitae accumsan risus lacus sed sem metus."
textBytes = CharsetUtil.encode(text, CharsetUtil::CHARSET_GSM)
            
submit = SubmitSm.new

submit.setSourceAddress(Address.new(0x03, 0x00, "40404"))
submit.setDestAddress(Address.new(0x01, 0x01, "44555519205"))
submit.setShortMessage(textBytes)

session.sendRequestPdu(submit, 10000, false)

puts "Press enter to stop"
gets

session.destroy
clientBootstrap.destroy
executors.stop

