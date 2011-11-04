class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :authorized?

  protected

    def authorized?
      if !APP_CONFIG['perform_authentication'] || (session[:authorized] && session[:ip] == request.remote_ip)
        return true
      else
        return false
      end
    end

    def authorize
    unless authorized?
      flash[:error] = "Unauthorized access"
      redirect_to :root
      false
    end
  end
end
