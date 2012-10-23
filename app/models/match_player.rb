class MatchPlayer < ActiveRecord::Base
  belongs_to :match,  counter_cache: :player_count
  belongs_to :player, counter_cache: :match_count
  has_many   :match_players, class_name: 'MatchPlayer', foreign_key: 'match_id', primary_key: 'match_id'

  validates :winner, inclusion: {in: [true, false]}
  validates :team, numericality: {greater_than: 0}
end

