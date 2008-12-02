class Command

  FIFO = File.new(FIFO_NAME, 'a')

  attr_accessor(:call)

  def execute
    FIFO.print("#{self.call}\n")
    FIFO.flush
  end

end
