class QuestionariesController < ApplicationController
  before_filter :authorize

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
  
  def edit
    @questionary = Questionary.find(params[:id])
    @title = "Edit questionary"
  end
  
  def update
    @questionary = Questionary.find(params[:id])
    if @questionary.update_attributes(params[:questionary])
      redirect_to @questionary
    else
      render :edit
    end
  end
  
  def destroy
    Questionary.find(params[:id]).destroy
    redirect_to questionaries_path
  end
end
