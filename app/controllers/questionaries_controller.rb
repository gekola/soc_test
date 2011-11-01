class QuestionariesController < ApplicationController

  def show
    @questionary = Questionary.find(params[:id])
    @questions = @questionary.questions
    @title = @questionary.name
  end

  def index
    @title = "All questionaries"
    @questionaries = Questionary.all
  end
  
  def new
    @questionary = Questionary.new
    @title = "Creating new questionary"
  end
  
  def create
    @questionary = Questionary.new(params[:questionary])
    if @questionary.save
      @title = "Questionary #{@questionary.name} created!"
      redirect_to @questionary
      # Maybe it should redirect to other page, but we will decide it later
    else
      @title = "Creating new questionary"
      render :new
    end
  end
end
