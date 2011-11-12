class ResultInformationValidator < ActiveModel::Validator
  def validate(record)
    record.information.each do |q_id,value|
      question = record.questionary.questions.where("num=#{q_id}")[0]
      if question.nil?
        record.errors[:information] << "Question number #{q_id} does not seem to exist"
      else 
        value.each do |a_id|
          unless question.answers.where("num=#{a_id}").size.equal? 1
            record.errors[:information] << "Question #{q_id} has no answer number #{a_id}"
          else
            ans = question.answers.where("num=#{a_id}").first 
            record.errors[:information] << "A new answer #{a_id} (question #{q_id}) does not belong to the result" unless ans.verified? | ans.result.equal?(record)
          end
        end
      end
    end
  end
end

class Result < ActiveRecord::Base
  attr_accessible :information
  
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
