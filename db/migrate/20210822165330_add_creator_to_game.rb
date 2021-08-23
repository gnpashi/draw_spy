class AddCreatorToGame < ActiveRecord::Migration[6.1]
  def change
    add_column :games, :creator, :bigint
  end
end
