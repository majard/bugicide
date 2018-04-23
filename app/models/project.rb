class Project < ApplicationRecord
    has_many :bugs
    
  def to_s
    name
  end
end
