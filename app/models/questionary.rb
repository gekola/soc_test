class Questionary < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :questions, :dependent => :destroy

  validates :name, :presence => true

end
