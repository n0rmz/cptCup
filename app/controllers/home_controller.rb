class HomeController < ApplicationController
  before_filter :calculate_data, :only => [:comparisons, :comparisons2, :comparisons3, :index]
  def index
    @player = Player.new
    @players = Player.all
    @game = Game.new
    @game.build_default_assocations
    @num_games = Game.count
  end

  private

  def calculate_data
    game_hash = {}
    Game.all.each do |g|
      game_hash[g.winner_one_id] = PlayerComparison.new unless game_hash[g.winner_one_id]
      game_hash[g.winner_two_id] = PlayerComparison.new unless game_hash[g.winner_two_id]
      game_hash[g.loser_one_id] = PlayerComparison.new unless game_hash[g.loser_one_id]
      game_hash[g.loser_two_id] = PlayerComparison.new unless game_hash[g.loser_two_id]

      game_hash[g.winner_one_id].add_wins_against(g.loser_one_id, g.loser_two_id)
      game_hash[g.winner_two_id].add_wins_against(g.loser_one_id, g.loser_two_id)
      game_hash[g.loser_one_id].add_loses_against(g.winner_one_id, g.winner_two_id)
      game_hash[g.loser_two_id].add_loses_against(g.winner_one_id, g.winner_two_id)
    end
    @game_hash = {}
    game_hash.to_a.each {|arr| @game_hash[arr.first] = arr.last.against_hash.to_a}
    @players_hash = Player.all.inject({}) {|hash, p| hash[p.id] = p.name; hash}
    @player_rankings = Game.calculate_rankings(Game.all)
  end
end
