class CommandsController < ApplicationController

  def new
    @command = Command.new
  end

  def update
    @command = Command.new
    @command.call = params[:command][:call]
    @command.execute
  end
end
