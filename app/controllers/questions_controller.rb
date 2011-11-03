class QuestionsController < ApplicationController
  
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
    #@title = @question.num
  end
  
  def new
    @questionary = Questionary.find_by_id(params[:questionary_id])
    @question = Question.new
    @title = "Creating new question"
  end
  
  def create
    @questionary = Questionary.find_by_id(params[:questionary][:id])
    @question = @questionary.questions.build(params[:question])
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end
end
