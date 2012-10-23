class Sport < ActiveRecord::Base
  validates :name, presence: true
end

