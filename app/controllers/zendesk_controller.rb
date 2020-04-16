class Watchdog::ZendeskController < ApplicationController
  def unanswered_tickets
    render json: [[Time.now, 2], [Time.now, 2]]
  end
end
