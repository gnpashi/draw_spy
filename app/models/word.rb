class Word < ApplicationRecord
    has_many :games, dependent: :destroy

    def to_s
        self.title
    end
end
