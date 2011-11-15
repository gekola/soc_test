module SessionsHelper
  def setSessionParams(params)
    params.each do |key,value|
      session[key] = value
    end
    session[:ip] = request.remote_ip
  end
end
