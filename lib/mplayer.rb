require 'thread'
require 'singleton'

class Mplayer

  include Singleton

  attr_accessor :recent, :log

  def initialize( opts = '' )
    @recent = [ DEFAULT_URL ]
    @log = [ ]
    debug 'initializing mplayer singleton'
    ObjectSpace.define_finalizer self, Mplayer.create_finalizer(self)
  end

  def close
    execute 'quit'
    @io.try(:close)
    @io_thread.join(0.5) unless @io_thread.nil?
    sleep 1
    `pkill -9 #{MPLAYER_BIN}` # leave no witnesses behind
  end

  def play( path )
    close
    return debug('sorry, only http supported...') unless path =~ /^http/
    path.gsub! /[^\w\.\:\-\=\/\?\&\ ]/, ''
    cmd = "#{MPLAYER_BIN} #{MPLAYER_OPT} '#{path}' 2>&1"
    debug(cmd)
    @io = IO.popen(cmd, 'r+')
    @recent.insert(0, path)
    @recent.uniq!
    @io_thread = Thread.new(self) { |p|  p.read_thread }
  end

  def pause
    execute "pause"
  end

  def volume_up
    execute 'volume 20'
  end
   
  def volume_down
    execute 'volume -20'
  end

  def seek_left
    execute 'seek -60 0'
  end

  def seek_right
    execute 'seek +60 0'
  end

protected

  def read_thread
    buff = ''
    begin
      until @io.eof?
        buff += @io.read 1
        next unless (i = buff.index(/[\r\n]/))

        debug buff.slice!(0, i+1).strip
      end
    rescue
      return
    end
  end

  def Mplayer.create_finalizer( player )
    proc {  player.close  }
  end

  def execute(cmd)
    debug cmd
    @io.puts cmd
  rescue => error
    RAILS_DEFAULT_LOGGER.error(error)
    debug error
  end

  def debug(msg)
    RAILS_DEFAULT_LOGGER.info(msg)
    @log.insert(0, msg)
    @log.pop while @log.length > 100
  end

end
