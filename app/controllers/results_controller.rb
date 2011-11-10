class ResultsController < ApplicationController
  before_filter :authorize, :only => :index
  
  def index
    @title = "All results"
    @results = Result.all
  end
  
  def new
    redirect_to form_path
  end
  
  def create
    #temporary solution, need to discuss later
    default_questionary_id = 1
    begin
      @questionary = Questionary.find_by_id(default_questionary_id)
      @result = @questionary.results.build()
      validRes = @result.save
      answers = params[:answers]
      answers = answers.map do |key,value|  
	case key
	when /\d+_checked/
	  key.split('_')[0].to_i
	when /\d+_extra/
	  question = Question.find_by_id(key.split('_')[0])
	  if question.extra_answer
	    unless value.blank? || answers[question.id.to_s]!='new'
	      num = question.answers.max.num+1
	      attr = {:num => num, :content => value, :verified => false}
	      createAns = Answer.new(attr)
	      createAns.question = question
	      createAns.result = @result
	      if createAns.save
		createAns.id
	      else
		validRes = false
		nil
	      end
	    end
	  else
	    validRes = false
	    nil
	  end
	when /\d+/
	  value.to_i if value!='new'
	else
	  validRes = false
	  nil
	end
      end
    rescue
      validRes = false
    end
    
    
    begin
      answers.compact!
      answers.map! { |ans| Answer.find_by_id(ans) }
      if answers.map { |ans| ans.question_id }.sort.uniq != @questionary.questions.map { |q| q.id }.sort
	validRes = false
      else
	@result.answers = answers
      end
    rescue
      validRes = false
    end
    
    if validRes
      #it should redirect to a thx page, but we don't have it yet
      redirect_to root_path
    else
      @result.destroy if !@result.nil? && !@result.id.nil?
      redirect_to form_path
    end      
  end
end
