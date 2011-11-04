class QuestionsController < ApplicationController
  before_filter :authorize

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

  def edit
    @question = Question.find(params[:id])
    @title = "Edit question"
  end

  def update
    @question = Question.find(params[:id])
    if @question.update_attributes(params[:question])
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    #@question = Question.find(params[:id])
    #redir_url = url_for(@question.questionary)
    #@question.destroy
    #redirect_to redir_url
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to @question.questionary
  end
end
