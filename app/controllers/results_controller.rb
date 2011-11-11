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
	  question = Question.find_by_id(key.split('_')[0].to_i)
	  if question.multians >1
	    ans_id = createNewAns(question,value) if answers["#{question.id}_new_checked"]=="1"
	  else
	    ans_id = createNewAns(question,value) if answers[question.id.to_s]=='new'
	  end
	  if ans_id!=0
	    ans_id
	  else
	    validRes = false
	    nil
	  end
	when /\d+_new_checked/
	  nil
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
	@result.update_attributes(:information => answers)
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
  
  private
  def createNewAns(question, value)
    if question.extra_answer
      unless value.blank?
	existAns = Answer.find {|a| a.content==value && a.question_id==question.id }
	if existAns.nil?
	  num = question.answers.max.num+1
	  attr = {:num => num, :content => value, :verified => false}
	  createAns = Answer.new(attr)
	  createAns.question = question
	  createAns.result = @result
	  if createAns.save
	    return createAns.id
	  else
	    return 0
	  end
        else
	  return existAns.id
	end
    end
    else
      return 0
    end
  end  
end
