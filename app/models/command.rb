class Command

  @@FIFO = File.new(FIFO_NAME, 'a')
  @@LOG = RAILS_DEFAULT_LOGGER

  attr_accessor(:call)

  def initialize(c)
    @call = c
  end

  def execute
    @@LOG.info("executing #{sanitized_call}")
    @@FIFO.print("#{sanitized_call}\n")
    @@FIFO.flush
  end

  def sanitized_call
    @call.gsub /[^\w\.\:\-\/\?\ ]/, ''
  end

end
