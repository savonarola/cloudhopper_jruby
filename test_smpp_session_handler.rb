java_import 'com.cloudhopper.smpp.impl.DefaultSmppSessionHandler'
java_import 'java.lang.ref.WeakReference'

class TestSmppSessionHandler < DefaultSmppSessionHandler
  
  def initialize(session)
    @session_ref = WeakReference.new(session)
    super()
  end

  def firePduRequestReceived(pduRequest)
    session = @session_ref.get
    pduRequest.createResponse
  end

end


