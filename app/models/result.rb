module M
  attr :i

  def i=(x)
    @i=x
  end

  def to_i
    @i
  end
end

class ResultInformationValidator < ActiveModel::Validator
  def validate(record)

    b={}

    record.information.each do |a_id|
      answer = Answer.find_by_id(a_id)
      if answer.nil?
        add_err(record, a_id, "Answer with id = #{a_id} does not seem to exist")
      else
        add_err(record, a_id, "Question ##{answer.question.num} does not " +
                "belong to the same questionary as the result") if
          answer.question.questionary_id != record.questionary_id

        add_err(record, a_id, "A new answer ##{Answer.find(a_id).num}" +
                "(question ##{answer.question.num}) does not belong to the result") if
          !answer.verified? && answer.result_id != record.id
        b[answer.question.id] = b[answer.question.id].nil? ? 1 : b[answer.question.id] + 1
      end
    end
    record.questionary.questions.each do |question|
      if b[question.id].nil?
        add_err(record, question.answers.first.id, "No answers for question ##{question.num}")
      else
        add_err(record, (question.answers.where(:verified => true).map do |a|
                           a.id
                         end & record.information).sort.last,
                "Too many answers choosen for question ##{question.num}" +
                "(#{b[question.id]} choosen, maximum is #{question.multians})") if
          b[question.id]>question.multians
      end
    end
  end

  private
  def add_err(record,num,msg)
    a = msg
    class << a
      include M
    end
    a.i=num
    record.errors[:information] << a
  end
end

class Result < ActiveRecord::Base
  attr_accessible :information
  serialize :information, Array

  has_many :answers
  belongs_to :questionary
  after_destroy :cleanup

  validates :information, :presence => true
  validates :questionary_id, :presence => true
  validates_with ResultInformationValidator, :if => "information.present?&questionary.present?"

  private
  def cleanup
    self.answers.find_all{ |ans| !ans.verified }.each{ |a| a.destroy }
  end
end
