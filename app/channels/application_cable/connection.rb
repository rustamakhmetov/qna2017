module ApplicationCable
  class Connection < ActionCable::Connection::Base
    def connect
      Rails.logger.info "Websocket connect"
      # if cookies[:secret] != "123"
      #   Rails.logger.info "Reject connection"
      #   reject_unauthorized_connection
      # end
    end

    def disconnect

    end
  end
end
