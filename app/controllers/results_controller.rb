class ResultsController < ApplicationController
  before_filter :authorize, :only => :index

  def index
    @title = "All results"
    @results = Result.all
  end

  def new
    unless session[:can_see_form]
      redirect_to root_path;
    else
      session[:can_see_form] = false
    end
    @questionary = Questionary.first
    @result = Result.new
    @title = "Form"
  end

  def create
    unless session[:can_post]
      redirect_to thanks_path
    else
      #temporary solution, need to be discussed later
      default_questionary_id = Questionary.first
      begin
        @questionary = Questionary.find_by_id(default_questionary_id)
        @result = @questionary.results.build()
        validRes = @result.save(:validate => false)
        answers = params[:answers]
        answers = answers.map do |key,value|
	  case key
	  when /_\d+_checked/
	    key.split('_')[1].to_i
	  when /_\d+_extra/
	    question = Question.find_by_id(key.split('_')[1].to_i)
	    if question.multians >1
	      ans_id = createNewAns(question,value) if answers["_#{question.id}_new_checked"]=="1"
	    else
	      ans_id = createNewAns(question,value) if answers["_"+question.id.to_s]=='new'
	    end
	    if ans_id!=0
	      ans_id
	    else
	      validRes = false
	      nil
	    end
	  when /_\d+_new_checked/
	    nil
	  when /_\d+/
	    value.to_i if value!='new' && Answer.find_by_id(value.to_i).question_id==key.split('_')[1].to_i
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
        validRes = @result.update_attributes(:information => answers)
      rescue
        validRes = false
      end

      if validRes
	cookies[:successfully_posted] = { :value => true,
	                                  :expires => 10.years.from_now.utc }
        reset_session
        redirect_to thanks_path
      else
        @result.destroy if !@result.nil? && !@result.id.nil?
        @result = @questionary.results.build
        @result.information = answers
        @result.valid?
        #generating an object for auto fill-in fields after re-render
        @answers = Object.new
        answers = params[:answers]
        answers.each do |key,value|
	  @answers.instance_eval "def #{key}= (val)
	                            instance_variable_set(\'@#{key}\', val)
                                  end"
	  @answers.instance_eval "def #{key}
	                            instance_variable_get(\'@#{key}\')
                                  end"
        end
        @answers.instance_eval "def fieldEqual?(field, value)
                                  if respond_to?(\"\#\{field}\")
                                    send(\"\#\{field}\")==value
                                  else
                                    false
                                  end
                                end"
        answers.each do |key,value|
	  @answers.send("#{key}=",value)
        end
        flash.now[:error] = "Something went wrong. We can't parse you answers.
Please make sure, that you fill in everything correctly." # filled the form/questionary?
        render :new
      end
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
