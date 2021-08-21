json.extract! player, :id, :kind, :name, :game_id, :created_at, :updated_at
json.url player_url(player, format: :json)
