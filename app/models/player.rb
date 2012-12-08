require_dependency 'player_query'

class Player < ActiveRecord::Base
  has_many :match_players
  has_many :matches, through: :match_players

  validates :name, presence: true

  default_scope order('name ASC')

  def appearances
    @apperances ||= (read_attribute(:appearances) || match_players.count).to_i
  end

  def wins
    @wins ||= (read_attribute(:wins) || match_players.won.count).to_i
  end

  def losses
    appearances - wins
  end

  def ratio
    if appearances > 0
      (wins / appearances.to_f)
    else
      0
    end
  end

  def opponents_for!
    @opponents ||= match_players.map do |mp|
      mp.match.match_players.where('winner != ?', mp.winner).includes(:player).map(&:player)
    end.flatten.uniq
  end

  def opponents_for
    PlayerQuery.opponents_for(self).execute.to_a
  end
end

