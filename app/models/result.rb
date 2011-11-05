class Result < ActiveRecord::Base
  attr_accessible :information

  has_many :answers
  belongs_to :questionary

  validates :information, :presence => true
  validates :questionary_id, :presence => true

end
