class QuestionariesController < ApplicationController

  def show
    @questionary = Questionary.find(params[:id])
    @questions = @questionary.questions
    @title = @questionary.name
  end
end
