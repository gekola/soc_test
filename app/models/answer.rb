class Answer < ActiveRecord::Base
  attr_accessible :num, :content

  belongs_to :question
  belongs_to :result

end
