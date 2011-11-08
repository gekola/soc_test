class AnswersController < ApplicationController
  before_filter :authorize

  def new
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new
    @title = "Creating new answer"
  end

  def create 
    if params[:verified]==nil
      params[:answer][:verified] = true
    else
      params[:answer].merge(:verified => params[:verified])
    end
    @question = Question.find_by_id(params[:question][:id])
    @answer = @question.answers.build(params[:answer])
    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def edit
    @answer = Answer.find(params[:id])
    @title = "Edit answer"
  end

  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      redirect_to @answer.question
    else
      render :edit
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    redirect_to @answer.question
  end
end
