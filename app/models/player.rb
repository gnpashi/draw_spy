class Player < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :game
  validates :name, presence: true
  default_scope { order(created_at: :asc) }
  enum kind: [:regular, :spy], _default: :regular

  after_create_commit do
    broadcast_replace_to [game, :players], target: "#{dom_id(game)}_players", partial: "players/game_players", locals: {game: game}
  end

end
