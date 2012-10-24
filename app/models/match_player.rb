class MatchPlayer < ActiveRecord::Base
  belongs_to :match,  counter_cache: :player_count
  belongs_to :player, counter_cache: :match_count

  validates :winner, inclusion: {in: [true, false]}
  validates :team, numericality: {greater_than: 0}

  scope :won, where(winner: true)
end

