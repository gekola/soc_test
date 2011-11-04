module ApplicationHelper

  def title
    base_title = "Survey Research"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def authorized?
    if session[:authorized] && session[:ip] == request.remote_ip
      return true
    else
      return false
    end
  end
end
