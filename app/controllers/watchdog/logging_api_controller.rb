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

    def get_latest_file_for(period)
      files = S3_BUCKET.list_objects_v2(
        bucket: 'govwifi-staging-metrics-bucket',
        prefix: "active-users-#{period}"
      )

      latest = files
               .contents
               .sort_by(&:last_modified)
               .reverse
               .first
               .key

      S3_BUCKET.get_object(
        bucket: 'govwifi-staging-metrics-bucket',
        key: latest
      )
    end

    def extract_data_for(period)
      raw = get_latest_file_for(period)

      data = JSON.parse(raw.body.read)

      data['data'].filter { |entry| entry['period'] == period }
    end
  end
end
