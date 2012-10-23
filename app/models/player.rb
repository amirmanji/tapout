class Player < ActiveRecord::Base
  has_many :match_players
  has_many :matches, through: :match_players

  validates :name, presence: true

  def self.opponents_for(player)
    self.where(arel_table[:id].not_eq(player.id)).
      joins('INNER JOIN match_players mp1 ' <<
            'ON mp1.player_id = players.id').
      joins('INNER JOIN match_players mp2 ' <<
            'ON mp2.match_id = mp1.match_id AND ' <<
            'mp2.team != mp1.team AND ' <<
            'mp2.player_id != mp1.player_id').
      group(arel_table[:id]).
      select('players.*, COUNT(mp2.match_id) AS appearances, SUM(mp2.winner) AS wins')
  end

  def opponents
    self.class.opponents_for(self)
  end

  def opponents_by_ratio
    opponents.sort { |a,b| b.ratio <=> a.ratio }
  end

  def toughest_opponent
    opponents_by_ratio.first
  end

  def easiest_opponent
    opponents_by_ratio.last
  end

  def self.partners_for(player)
    self.where(arel_table[:id].not_eq(player.id)).
      joins('INNER JOIN match_players mp1 ' <<
            'ON mp1.player_id = players.id').
      joins('INNER JOIN match_players mp2 ' <<
            'ON mp2.match_id = mp1.match_id AND ' <<
            'mp2.team = mp1.team AND ' <<
            'mp2.player_id != mp1.player_id').
      group(arel_table[:id]).
      select('players.*, COUNT(mp2.match_id) AS appearances, SUM(mp2.winner) AS wins')
  end

  def partners
    self.class.partners_for(self)
  end

  def partners_by_ratio
    partners.sort { |a,b| b.ratio <=> a.ratio }
  end

  def best_partner
    partners_by_ratio.first
  end

  def worst_partner
    partners_by_ratio.last
  end

  def appearances
    read_attribute(:appearances).to_i || 0
  end

  def wins
    read_attribute(:wins).to_i || 0
  end

  def ratio
    if appearances > 0
      (wins / appearances.to_f)
    else
      0
    end
  end
end

