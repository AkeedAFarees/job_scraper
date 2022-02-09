require "google/apis/sheets_v4"
require "google_credentials" # We made this.

class GoogleSheetsService
  include GoogleCredentials
  attr_reader :service
  def self.service
    new.service
  end
  private
  def initialize
    @service = freshly_authorized_service
  end
  def freshly_authorized_service
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = make_credentials!
    service
  end
end