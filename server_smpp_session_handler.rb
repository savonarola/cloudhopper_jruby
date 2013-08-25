java_import 'com.cloudhopper.smpp.impl.DefaultSmppSessionHandler'

class ServerSmppSessionHandler < DefaultSmppSessionHandler
  def firePduRequestReceived(pduRequest)
    pduRequest.createResponse
  end
end


