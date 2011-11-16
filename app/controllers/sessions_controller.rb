include SessionsHelper

class SessionsController < ApplicationController

  def new
    @title = "Authentication"
  end

  def create
    reset_session
    if authenticate(params[:session][:password])
      setSessionParams(:authorized => true, :can_post => true)
      redirect_to :questionaries
    else
      flash.now[:error] = "Invalid password."
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to :root
  end

  private
    def authenticate(password)
      return true if password ==
        (ENV['password'] || "secret")
    end
end
