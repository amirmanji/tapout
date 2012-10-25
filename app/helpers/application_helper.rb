module ApplicationHelper
  def format_player(player)
    "#{player.name} (#{player.score}) (#{player.appearances})"
  end
end
