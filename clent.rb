require 'jruby_helpers'
extend JrubyHelpers

require 'ch-smpp-5.0.2'
require_jars 'deps'

import_java %w{
  com.cloudhopper.commons.charset.CharsetUtil
  com.cloudhopper.commons.util.windowing.WindowFuture
  com.cloudhopper.smpp.SmppSessionConfiguration
  com.cloudhopper.smpp.SmppBindType
  com.cloudhopper.smpp.SmppSession
  com.cloudhopper.smpp.impl.DefaultSmppClient
  com.cloudhopper.smpp.impl.DefaultSmppSessionHandler
  com.cloudhopper.smpp.type.Address
  com.cloudhopper.smpp.pdu.EnquireLink
  com.cloudhopper.smpp.pdu.EnquireLinkResp
  com.cloudhopper.smpp.pdu.PduRequest
  com.cloudhopper.smpp.pdu.PduResponse
  com.cloudhopper.smpp.pdu.SubmitSm
  com.cloudhopper.smpp.pdu.SubmitSmResp
  java.util.concurrent.Executors
  java.util.concurrent.ScheduledThreadPoolExecutor
  java.util.concurrent.ThreadFactory
  java.util.concurrent.ThreadPoolExecutor
  java.util.concurrent.atomic.AtomicInteger
}

class ClientSmppSessionHandler < DefaultSmppSessionHandler
  def fireExpectedPduResponseReceived(response)
    puts "ClientSmppSessionHandler: response: #{response}"
  end
end

class MyThreadFactory
  def initialize
    @sequence = AtomicInteger.new(0)
  end

  def newThread(runnable)
    java.lang.Thread.new(runnable).tap do |t|
      t.setName("SmppClientSessionWindowMonitorPool-#{@sequence.getAndIncrement}")
    end
  end
end

executor = Executors.newCachedThreadPool
monitorExecutor = Executors.newScheduledThreadPool(1, MyThreadFactory.new)

clientBootstrap = DefaultSmppClient.new(executor, 1, monitorExecutor)
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

sleep(1)

session.destroy
clientBootstrap.destroy
executor.shutdownNow
monitorExecutor.shutdownNow

