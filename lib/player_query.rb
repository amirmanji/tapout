require_dependency 'player_results'

class PlayerQuery
  attr_accessor :player, :query
  attr_reader :join

  def initialize(player, &blk)
    @player = player
    @query  = players.from(players.name)
    instance_eval(&blk) if block_given?
  end

  def execute
    if single_record?
      Player.find_by_sql(to_sql).first
    else
      PlayerResults.new(to_sql)
    end
  end

  def single_record?
    query.ast.limit.present? && query.ast.limit.value == 1
  end

  def multi_record?
    query.ast.limit.nil? || query.ast.limit.value > 1
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

  def count_matches
    query.project matches[:match_id].count.as('appearances'),
                  matches[:winner].sum.as('wins'),
                  Arel::SqlLiteral.new("(SUM(`matches`.`winner`) / COUNT(`matches`.`match_id`))").as('ratio')
    return self
  end

  def count_opposing
    query.project opposing[:match_id].count.as('appearances'),
                  opposing[:winner].sum.as('wins'),
                  Arel::SqlLiteral.new("(SUM(`opposing`.`winner`) / COUNT(`opposing`.`match_id`))").as('ratio')
    return self
  end

  def singles
    query.where count_query.eq(2)
    return self
  end

  def teams
    query.where count_query.gt(2)
    return self
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
    result = query.send(*args)

    if [:to_dot, :to_sql].include?(args.first)
      result
    else
      self
    end
  end

  private
  def arel_table(name)
    Arel::Table.new(name)
  end

  def count_query
    submatch = arel_table(:match_players)
    subquery = submatch.where submatch[:match_id].eq(matches[:match_id])
    subquery.project submatch[:match_id].count
    Arel::SqlLiteral.new("(#{subquery.to_sql})")
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

    def best_opponent_for(player)
      opponents_for(player).order('ratio DESC').take(1)
    end

    def worst_opponent_for(player)
      opponents_for(player).order('ratio ASC').take(1)
    end

    def singles_opponents_for(player)
      opponents_for(player).singles
    end

    def best_singles_opponent_for(player)
      singles_opponents_for(player).order('ratio DESC').take(1)
    end

    def worst_singles_opponent_for(player)
      singles_opponents_for(player).order('ratio ASC').take(1)
    end

    def team_opponents_for(player)
      opponents_for(player).teams
    end

    def best_team_opponent_for(player)
      team_opponents_for(player).order('ratio DESC').take(1)
    end

    def worst_team_opponent_for(player)
      team_opponents_for(player).order('ratio ASC').take(1)
    end

    def partners_for(player)
      for_opposing(player) {
        join.on opposing[:match_id].eq(matches[:match_id]),
                opposing[:player_id].eq(player.id),
                opposing[:team].eq(matches[:team])
      }
    end

    def best_partner_for(player)
      partners_for(player).order('ratio DESC').take(1)
    end

    def worst_partner_for(player)
      partners_for(player).order('ratio ASC').take(1)
    end

    def singles_partners_for(player)
      partners_for(player).singles
    end

    def best_singles_partner_for(player)
      singles_partners_for(player).order('ratio DESC').take(1)
    end

    def worst_singles_partner_for(player)
      singles_partners_for(player).order('ratio ASC').take(1)
    end

    def team_partners_for(player)
      partners_for(player).teams
    end

    def best_team_partner_for(player)
      team_partners_for(player).order('ratio DESC').take(1)
    end

    def worst_team_partner_for(player)
      team_partners_for(player).order('ratio ASC').take(1)
    end
  end
end

