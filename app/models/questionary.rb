class Questionary < ActiveRecord::Base
  attr_accessible :description

  has_many :questions, :dependent => :destroy

end
