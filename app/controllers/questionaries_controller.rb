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
end
