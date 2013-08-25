require 'server_smpp_session_handler'
require 'bind_type_human'
require 'session_info'
java_import 'org.slf4j.LoggerFactory'

class ServerHandler
  attr_accessor :logger

  def initialize
    @logger = LoggerFactory.getLogger("ServerHandler")
    @sessions = {}
  end

  def sessionBindRequested(sessionId, sessionConfiguration, bindRequest)
    sessionConfiguration.setName("Application.SMPP.#{sessionConfiguration.getSystemId}")
  end

  def sessionCreated(sessionId, session, preparedBindResponse)
    logger.info("session created: #{session}")
    @sessions[sessionId] = session
    session.serverReady(ServerSmppSessionHandler.new)
  end

  def sessionDestroyed(sessionId, session)
    logger.info("session destroyed: #{session}")
    @sessions.delete(sessionId)
    session.destroy
  end

  def listSessions
    @sessions.map do |sessionId, session|
      SessionInfo.new(sessionId, session.getSystemId, BindTypeHuman.new(session.getBindType))
    end
  end

  def sendPdu(sessionInfo, pdu)
    sessionId = sessionInfo.id
    session = @sessions[sessionId]
    raise "Session with id #{sessionId} not found" unless session
    session.sendRequestPdu(pdu, 10000, false)
  end

end

