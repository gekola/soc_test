class Result < ActiveRecord::Base
  attr_accessible :information

  belongs_to :questionary

end
