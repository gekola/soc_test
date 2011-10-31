class Question < ActiveRecord::Base
  attr_accessible :num, :content

  has_many :answers, :dependent => :destroy

  belongs_to :questionary

  validates :num, :presence => true
  validates :content, :presence => true

end
