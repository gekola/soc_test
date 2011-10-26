class Question < ActiveRecord::Base
  attr_accessible :num, :content

  has_many :answers

  belongs_to :questionary

end
