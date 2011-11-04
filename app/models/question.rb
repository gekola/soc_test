class Question < ActiveRecord::Base
  attr_accessible :num, :content

  has_many :answers, :dependent => :destroy

  belongs_to :questionary

  validates :num, :presence => true, :uniqueness => true
  validates :content, :presence => true, :length => { :maximum => 140 }
  validates :questionary_id, :presence => true
  
  def to_format_s
    "#{num}. #{content}"
  end
end
