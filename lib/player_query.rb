class PlayerQuery
  attr_accessor :player, :query
  attr_reader :join

  def initialize(player, &blk)
    @player = player
    @query  = players.from(players.name)
    instance_eval(&blk) if block_given?
  end

  def execute
    Player.find_by_sql self.to_sql
  end

  def to_sql
    query.to_sql
  end

  def count_matches
    query.project matches[:match_id].count.as('appearances'),
                  matches[:winner].sum.as('wins')
    return self
  end

  def count_opposing
    query.project opposing[:match_id].count.as('appearances'),
                  opposing[:winner].sum.as('wins')
    return self
  end

  def with_matches(&blk)
    @join = query.join matches
    instance_eval &blk
    @join = nil
    return self
  end

  def with_opposing(&blk)
    @join = query.join opposing
    instance_eval &blk
    @join = nil
    return self
  end

  def count_query
    submatch = arel_table(:match_players)
    subquery = submatch.where submatch[:match_id].eq(matches[:match_id])
    subquery.project submatch[:match_id].count
    Arel::SqlLiteral.new("(#{subquery.to_sql})")
  end

  def players
    @players ||= arel_table(:players)
  end

  def matches
    @matches ||= arel_table(:match_players).alias('matches')
  end

  def opposing
    @opposing ||= arel_table(:match_players).alias('opposing')
  end

  def method_missing(*args)
    query.send(*args)
    return self
  end

  private
  def arel_table(name)
    Arel::Table.new(name)
  end

  class <<self
    def for(player)
      new(player) do
        query.where players[:id].eq(player.id)
        query.project players.columns
        query.group players[:id]
      end
    end

    def not_for(player)
      new(player) do
        query.where players[:id].not_eq(player.id)
        query.project players.columns
        query.group players[:id]
      end
    end

    def for_opposing(player, &blk)
      not_for(player).count_opposing.with_matches {
        join.on matches[:player_id].eq(players[:id])
      }.with_opposing(&blk)
    end

    def opponents_for(player)
      for_opposing(player) {
        join.on opposing[:match_id].eq(matches[:match_id]),
                opposing[:player_id].eq(player.id),
                opposing[:team].not_eq(matches[:team])
      }
    end

    def singles_opponents_for(player)
      opponents_for(player).singles
    end

    def team_opponents_for(player)
      opponents_for(player).teams
    end

    def partners_for(player)
      for_opposing(player) {
        join.on opposing[:match_id].eq(matches[:match_id]),
                opposing[:player_id].eq(player.id),
                opposing[:team].eq(matches[:team])
      }
    end
  end
end

