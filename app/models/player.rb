require_dependency 'player_query'

class Player < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  has_many :match_players
  has_many :matches, through: :match_players

  validates :name, presence: true

  default_scope order('name ASC')

  def appearances
    (read_attribute(:appearances) || match_players.count).to_i
  end
  memoize :appearances

  def wins
    (read_attribute(:wins) || match_players.won.count).to_i
  end
  memoize :wins

  def ratio
    if appearances > 0
      (wins / appearances.to_f)
    else
      0
    end
  end
end

