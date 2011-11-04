class AnswersController < ApplicationController
  
  def new
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new
    @title = "Creating new answer"
  end
  
  def create
    @question = Question.find_by_id(params[:question][:id])
    @answer = @question.answers.build(params[:answer])
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end
end
