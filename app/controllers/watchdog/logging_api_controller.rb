module Watchdog
  class LoggingApiController < ApplicationController
    def active_users_weekly
      data = extract_data_for 'week'

      data.map do |entry|
        ['_week_start_at', 'count'].map { |a| entry[a] }
      end
    end

    def active_users_monthly
      data = extract_data_for 'month'

      data.map do |entry|
        ['_month_start_at', 'count'].map { |a| entry[a] }
      end
    end

    private

    def extract_data_for(period)
      raw = S3_BUCKET.get_object(
        bucket: 'govwifi-mock-metrics',
        key: 'active_users.json'
      )

      data = JSON.parse(raw.body.read)

      data['data'].filter { |entry| entry['period'] == period }
    end
  end
end
