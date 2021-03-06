class PlayersController < ApplicationController
  include ActionView::RecordIdentifier

  before_action :set_player, only: %i[ show edit update destroy ]

  # GET /players or /players.json
  def index
    @players = Player.all
  end

  # GET /players/1 or /players/1.json
  def show
    puts "show".black.on_yellow
    if request.headers["turbo-frame"]
      if params[:destroy].present?
        render partial: 'game_players', locals: { game: Player.find(session[:player_id]).game }
      end
      render partial: 'spy', locals: { player: Player.find(session[:player_id]) }
    else
      render 'show'
    end
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players or /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        session[:player_id] = @player.id
        session[:new_player] = true
        if session[:creator]
          @player.game.update(creator: @player.id)
        end
        format.turbo_stream
        format.html { redirect_to @player.game, notice: "Player was successfully created." }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1 or /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: "Player was successfully updated." }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1 or /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to players_url, notice: "Player was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def turbo
    @player = Player.find(params[:id])
    @player.broadcast_remove_to("player_stream")
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to players_url }
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def player_params
      params.require(:player).permit(:kind, :name, :game_id)
    end
end
