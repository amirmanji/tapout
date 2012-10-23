Sport.create name: 'Ping Pong', base_points: 1
#Sport.create name: 'Beer Pong', base_points: 1
#Sport.create name: 'Darts', base_points: 1

%w(JLo Chot Sanders Stebar Tipton Pete Howie Kate John).each do |player|
  Player.create name: player
end

sport = Sport.first
1000.times do
  match = Match.create! sport: sport

  players = 2 * (1 + rand(2))
  players = Player.order('RAND()').limit(players).to_a.each_slice(players / 2).to_a

  winners = players.first
  losers  = players.last

  winners.each { |p| match.add_winner(p) }
  losers.each { |p| match.add_loser(p) }
end

