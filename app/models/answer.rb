class Answer < ActiveRecord::Base
  attr_accessible :num, :content, :verified

  belongs_to :question
  belongs_to :result

  validates_uniqueness_of :question_id, :scope => :num

  validates :num, :presence => true
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :question_id, :presence => true
  validates :verified, :inclusion => {:in => [true, false]}
 # validates :result_id, :presence => { :if => Proc.new{ |ans| !ans.verified } }

  def to_format_s
    "#{num}) #{content}"
  end

  def <=> other
    self.num <=> other.num
  end
end
