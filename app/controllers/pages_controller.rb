include SessionsHelper

class PagesController < ApplicationController

  def home
    reset_session
    if !cookies[:successfully_posted]
      can = true
    else
      can = false
    end
    setSessionParams(:authorized => false, :can_post => can)
  end

  def thanks
    reset_session
  end
end
