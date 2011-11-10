class Result < ActiveRecord::Base
  attr_accessible :information

  has_many :answers
  belongs_to :questionary
  after_destroy :cleanup

  #validates :information, :presence => true
  validates :questionary_id, :presence => true

  private
  def cleanup
    self.answers.find_all{ |ans| !ans.verified }.each{ |a| a.destroy }
  end
end
