class Game < ApplicationRecord
    include ActionView::RecordIdentifier

    extend FriendlyId
    friendly_id :uuid, use: :slugged
    belongs_to :word
    has_many :players, dependent: :destroy
    validates :uuid, uniqueness: true

    enum state: [:pending, :started], _default: :pending

    after_update_commit do
        broadcast_replace_to [self, :players], target: "#{dom_id(self)}_player_kind", partial: "players/spy_frame", locals: {game: self}
    end
end
