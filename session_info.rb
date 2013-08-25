class SessionInfo
  attr_reader :id, :system_id, :bind_type

  def initialize(id, system_id, bind_type)
    @id = id
    @system_id = system_id
    @bind_type = bind_type
  end

  def to_s
    "#{id}) bind_type: #{bind_type}, system_id: #{system_id}"
  end
end
  

