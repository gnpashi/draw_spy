module ApplicationHelper

    def current_player
        Player.find(session[:player_id])
    end
end
