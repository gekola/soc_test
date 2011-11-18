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

    t_prefix = 'errors.attributes.information.'
    b={}

    record.information.each do |a_id|
      answer = Answer.find_by_id(a_id)
      if answer.nil?
        add_err(record, a_id, I18n.t(t_prefix+'ans_not_exist', :a_id => a_id))
      else
        add_err(record, a_id, I18n.t(t_prefix+'external_q',
                                     :num => answer.question.num)) if
          answer.question.questionary_id != record.questionary_id

        add_err(record, a_id, I18n.t(t_prefix+'external_new_a',
                                     :ans => Answer.find(a_id).num,
                                     :quest => answer.question.num)) if
          !answer.verified? && answer.result_id != record.id
        b[answer.question.id].nil? ? b[answer.question.id]=0 : nil
        b[answer.question.id] += 1
      end
    end
    record.questionary.questions.each do |question|
      if b[question.id].nil?
        add_err(record, question.answers.first.id, I18n.t(t_prefix+'empty_q',
                                                          :quest => question.num))
      else
        add_err(record, (question.answers.where(:verified => true).map do |a|
                           a.id
                         end & record.information).sort.last,
                I18n.t(t_prefix+'too_many_a', :q_num => question.num,
                       :q_cho => b[question.id],
                       :q_max => question.multians)) if
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
