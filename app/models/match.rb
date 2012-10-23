class Match < ActiveRecord::Base
  belongs_to :sport, counter_cache: true
  has_many :match_players

  def add_winner(player)
    match_players.create(player: player, winner: true, team: 1)
  end

  def add_loser(player)
    match_players.create(player: player, winner: false, team: 2)
  end
end

