
class CommandsController < ApplicationController

  Mplayer.instance.public_methods(false).grep(/[^=]$/).each do |method|
    class_eval %{
      def #{method}
        Mplayer.instance.#{method}
        render_nothing
      end
    }
  end

  def play
    url = params[:url]
    Mplayer.instance.play(url)
    render :partial => 'info'
  end

  def info
    render :partial => 'info'
  end

  protected

    def render_nothing
      render :nothing => true
    end 
end
