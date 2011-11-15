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
      return true if !APP_CONFIG['perform_authentication'] ||
        encrypt(password) == APP_CONFIG['password_hash']
    end

    def encrypt(string)
      Digest::SHA2.hexdigest(string)
    end
end
