module UserInteraction
  class SessionChooser
    def initialize(server_handler)
      @server_handler = server_handler
    end

    def get_choice
      chosen = nil
      while !chosen 
        print_session_infoes
        chosen = read_choice
      end
      chosen
    end

    private

    def session_info_list
      @server_handler.listSessions
    end
      
    def print_session_infoes
      puts "Select session id:"
      session_info_list.each do |session_info|
        puts session_info
      end
      print "> "
    end

    def read_choice
      id_s = STDIN.gets.chomp
      return nil if id_s.empty?
      id = id_s.to_i
      session_info_list.find{|session_info| session_info.id == id}
    end
  end
end


