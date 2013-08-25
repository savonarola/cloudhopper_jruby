require 'user_interaction/session_chooser'
require 'user_interaction/deliver_sm_composer'

module UserInteraction
  class DeliverLoop
    def initialize(server_handler, ussd = false)
      @server_handler = server_handler
      @session_chooser = SessionChooser.new(@server_handler)
      @deliver_sm_composer = DeliverSmComposer.new(ussd)
    end

    def run
      run_without_exit_capture
    rescue SystemExit, Interrupt
      puts "Stopped by user"
    end

    private

    def run_without_exit_capture
      loop do
        session_info = @session_chooser.get_choice
        deliver_sm = @deliver_sm_composer.get_deliver_sm
        @server_handler.sendPdu(session_info, deliver_sm)
      end
    end
  end
end
