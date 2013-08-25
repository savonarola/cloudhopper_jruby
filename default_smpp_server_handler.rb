require 'test_smpp_session_handler'
java_import 'org.slf4j.LoggerFactory'

class DefaultSmppServerHandler
  attr_accessor :logger

  def initialize
    @logger = LoggerFactory.getLogger("DefaultSmppServerHandler")
  end

  def sessionBindRequested(sessionId, sessionConfiguration, bindRequest)
    sessionConfiguration.setName("Application.SMPP.#{sessionConfiguration.getSystemId}")
  end

  def sessionCreated(sessionId, session, preparedBindResponse)
    logger.info("session created: #{session}")
    session.serverReady(TestSmppSessionHandler.new(session))
  end

  def sessionDestroyed(sessionId, session)
    logger.info("session destroyed: #{session}")
    session.destroy
  end

end

