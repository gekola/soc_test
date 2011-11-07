class Questionary < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :questions, :dependent => :destroy
  has_many :results

  validates :name, :presence => true

end
