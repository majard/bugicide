class Bug < ApplicationRecord
  belongs_to :project
  
  def to_s
    "\nName: #{name}\nDescription: %{description}"
  end
end