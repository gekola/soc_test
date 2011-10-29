class Result < ActiveRecord::Base
  attr_accessible :information

  has_many :answers
  belongs_to :questionary

end
