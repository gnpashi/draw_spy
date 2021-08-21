class CreatePlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :players do |t|
      t.integer :kind
      t.string :name
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
