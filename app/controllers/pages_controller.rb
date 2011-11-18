include SessionsHelper

class PagesController < ApplicationController

  def home
    reset_session
  end

  def thanks
    unless session[:can_see_thanks]
      redirect_to root_path;
    else
      reset_session
    end
  end
end
