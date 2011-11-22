class AnswersController < ApplicationController
  before_filter :authorize

  def new
    @question = Question.find_by_id(params[:question_id])
    @answer = Answer.new
    @title = "Creating new answer"
  end

  def create
    if params[:verified].nil?
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

  def verify
    @questionary = Questionary.find(params[:q_id])
    @ans = @questionary.questions.map do |question|
      an_c = question.answers.where(:verified => false).first
      an_c.verified = true unless an_c.nil?
      an_c
    end.flatten.compact
    redirect_to @questionary if @ans.empty?
  end

  def join
    @left = Answer.find(params[:l_id])
    @right = Answer.find(params[:r_id])
    @result = @right.result
    @result.information.map! { |x| x == @right.id ? @left.id : x }.uniq!
    @result.answers.map! { |x| x == @right ? nil : x }.compact!
    destruct(@right)
    redirect_to url_for(:controller => :answers, :action => :verify, :q_id => @right.question.questionary.id)
  end

  def destroy
    @answer = Answer.find(params[:id])
    destruct(@answer)
    redirect_to @answer.question
  end

  private

  def destruct(answer)
    @start_num = answer.num
    answers = answer.question.answers
    answer.destroy
    answers.each do |answer|
      answer.num > @start_num ? answer.update_attributes!(:num => answer.num-1) : nil
    end
  end

end
