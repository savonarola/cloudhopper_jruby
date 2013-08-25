java_import 'com.cloudhopper.smpp.SmppBindType'

class BindTypeHuman < String
  def initialize(bind_type)
    human_bind_type = case bind_type
    when SmppBindType::TRANSCEIVER
      "trx"
    when SmppBindType::TRANSMITTER
      "tx"
    when SmppBindType::RECEIVER
      "rx"
    else
      "unknown"
    end
    super(human_bind_type)
  end
end
