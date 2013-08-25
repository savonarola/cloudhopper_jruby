require 'securerandom'
java_import 'com.cloudhopper.smpp.type.Address'
java_import 'com.cloudhopper.commons.charset.CharsetUtil'
java_import 'com.cloudhopper.smpp.pdu.DeliverSm'

module UserInteraction
  class DeliverSmComposer
    def initialize(ussd = false)
      @ussd = ussd
    end

    def get_deliver_sm
      from = get("'from' address")  
      to = get("'to' address")
      message = get("message text")
      compose_deliver_sm(from, to, message)
    end

    private

    def get(what)
      puts "Enter #{what}:"
      print "> "
      STDIN.gets.chomp
    end

    def compose_deliver_sm(from, to, message)
      dest = Address.new
      dest.setAddress(add_session_to_dest_address(to))

      source = Address.new
      source.setAddress(from)

      textBytes = CharsetUtil.encode(message, CharsetUtil::CHARSET_GSM)

      deliver = DeliverSm.new
      deliver.setSourceAddress(source)
      deliver.setDestAddress(dest)
      deliver.setShortMessage(textBytes)
      deliver
    end

    def add_session_to_dest_address(to)
      if @ussd
        "#{to}##{SecureRandom.hex(4)}"
      else
        to
      end
    end
  end
end

