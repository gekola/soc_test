class PagesController < ApplicationController

  def home
  end

  def form
    @questionary = Questionary.first
    @result = Result.new
  end
end
