class Answer < ActiveRecord::Base
  attr_accessible :num, :content

  belongs_to :question
  belongs_to :result

  validates :num, :presence => true
  validates :content, :presence => true

end
