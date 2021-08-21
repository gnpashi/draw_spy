class GamesController < ApplicationController
  before_action :set_game, only: %i[ show edit update destroy ]

  # GET /games or /games.json
  def index
    
    @game = Game.new
    session[:player_id] = nil
    session[:creator] = nil
    if params[:id].present?
      redirect_to "/#{params[:id].downcase}"
      
    end
  end

  # GET /games/1 or /games/1.json
  def show

    if session[:player_id].present?
      @player = Player.find(session[:player_id])
    else
      @player = Player.new
    end
    if request.headers["turbo-frame"]
      render partial: 'players/spy', locals: { player: @player }
    else
      render 'show'
    end
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
  end

  # POST /games or /games.json
  def create
    @game = Game.new(game_params)
    @game.uuid = SecureRandom.alphanumeric(5).downcase
    @game.word = Word.find(Word.pluck(:id).sample)
    while Game.find_by(uuid: @game.uuid).present?
      @game.uuid = SecureRandom.alphanumeric(5).downcase
    end
    session[:creator] = true
    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    @game.players.find(@game.players.pluck(:id).sample).update(kind: :spy)
    respond_to do |format|
      if @game.update(game_params)
        format.turbo_stream
        format.html { redirect_to @game, notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def playing
    @game = Game.friendly.find(params[:game_id])
    # 15.times do |i|
    #   @game.players.create(name: i)
    # end
    if @game.pending?
      @game.players.find(@game.players.pluck(:id).sample).update(kind: :spy)
      @game.update(state: :started)
    end
    @word = @game.word
    @player = Player.find(session[:player_id])
  end
  def all_games
    session[:player_id] = nil
    session[:creator] = nil
    @games = Game.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def game_params
      params.require(:game).permit( :state, :uuid)
    end
end
