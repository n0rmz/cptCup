class GamesController < ApplicationController
  before_filter :set_league

  # GET /games
  # GET /games.json
  def index
    @games = @league.games.order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = @league.games.build
    @game.build_default_assocations
    @players = Player.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
    @players = Player.all
  end

  # POST /games
  # POST /games.json
  def create
    @game = @league.games.build(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to league_path(@league), notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        @players = Player.all
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to league_game_path(@league, @game), notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to league_games_url }
      format.json { head :no_content }
    end
  end

  def odds
    @game = Game.new(params[:game])
    @players = Player.all

    respond_to do |format|
      @game.build_default_assocations unless @expected_outcome = @game.expected_outcome
      format.html {  }
    end
  end

  private

  def set_league
    @league = League.find(params[:league_id])
  end

end
