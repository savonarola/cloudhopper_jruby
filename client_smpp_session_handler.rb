java_import 'com.cloudhopper.smpp.impl.DefaultSmppSessionHandler'

class ClientSmppSessionHandler < DefaultSmppSessionHandler
  def fireExpectedPduResponseReceived(response)
    puts "ClientSmppSessionHandler: response: #{response}"
  end
end
