class ResultInformationValidator < ActiveModel::Validator
  def validate(record)
    b={}
    record.information.each do |a_id|
      answer = Answer.find_by_id(a_id)
      if answer.nil?
        a = "Answer with id = #{a_id} does not seem to exist"
        def a.to_i
          a_id
        end
        record.errors[:information] << a
      else
        if answer.question.questionary_id != record.questionary_id
          a = "Question ##{answer.question.num} does not " +
               "belong to the same questionary as the result"
          def a.to_i
            a_id
          end
          record.errors[:information] << a
        end
        if !answer.verified? && answer.result_id != record.id
          a = "A new answer ##{Answer.find(a_id).num} (question ##{answer.question.num}) " +
               "does not belong to the result"
          def a.to_i
            a_id
          end
          record.errors[:information] << a
        end
        b[answer.question.id] = b[answer.question.id].nil? ? 1 : b[answer.question.id] + 1
      end
    end
    record.questionary.questions.each do |question|
      if b[question.id].nil?
        a = "No answers for question ##{question.num}"
        def a.to_i
          question.answers.first.id
        end
        record.errors[:information] << a
      else
        if b[question.id]>question.multians
          a = "Too many answers choosen for question ##{question.num}" +
               "(#{b[question.id]} choosen, maximum is #{question.multians})"
          def a.to_i
            (question.answers.where(:checked => true).map{|a| a.id}&record).last
          end
          record.errors[:information] << a
        end
      end
    end
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
