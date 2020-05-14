# frozen_string_literal: true

def lookup_mock_data(key)
  path = Rails.root.join('test/fixtures/', key)

  if not File.exist?(path)
    raise "Could not find matching test data at #{path}"
  else
    { body: File.read(path) }
  end
end

if Rails.env.production?
  S3_BUCKET = Aws::S3::Client.new(region: 'eu-west-1')
else
  S3_BUCKET = Aws::S3::Client.new(region: 'eu-west-1', stub_responses: true)

  S3_BUCKET.stub_responses(
    :get_object,
    ->(context) { lookup_mock_data(context.params[:key]) }
  )
end
