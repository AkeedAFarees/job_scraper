require 'googleauth'

module GoogleCredentials
  CLIENT_ID = "584914619763-5c72rnaf5ki37ro5meabs640sesq2dae.apps.googleusercontent.com"
  CLIENT_SECRET = "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"
  REFRESH_TOKEN = "1//04ITF6KtehPTFCgYIARAAGAQSNwF-L9IrE7nW_rpeG50_vi_N04CBINI4b6NM7RP5C13O0s4mv3dsuMbGL5SZz3whz7CcNsSFIFI"
  SCOPES = [
    'https://www.googleapis.com/auth/spreadsheets.readonly',
  ].freeze

  def make_credentials!
    puts credentials_config
    creds = Google::Auth::UserRefreshCredentials.new(credentials_config)
    creds.refresh_token = REFRESH_TOKEN
    creds.fetch_access_token!
    creds
  end
  def credentials_config
    {
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      scope: SCOPES,
      additional_parameters: { 'access_type' => 'offline' },
    }
  end
end