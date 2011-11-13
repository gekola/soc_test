class ResultInformationValidator < ActiveModel::Validator
  def validate(record)
    record.information.each do |a_id|
      answer = Answer.find_by_id(a_id)
      if answer.nil?
        record.errors[:information] << "Answer ##{a_id} does not seem to exist"
      else
        record.errors[:information] << "Question ##{answer.question_id} does not " +
                                        "belongs to the same questionary as the result" if
          answer.question.questionary_id != record.questionary_id
        record.errors[:information] << "A new answer ##{a_id} (question ##{answer.question_id}) " +
                                        "does not belongs to the result" if
          !answer.verified? && answer.result_id != record.id
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
