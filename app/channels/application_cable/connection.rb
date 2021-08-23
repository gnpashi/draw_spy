module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :player_test
  end
end
