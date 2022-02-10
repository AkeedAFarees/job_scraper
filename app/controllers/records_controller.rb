class RecordsController < ApplicationController
  require "google_sheets_service"

  def new
    @record = Record.new
  end

  def create
    if record_params[:option] == "skill"
      Record.scrape(record_params[:skills])
    elsif record_params[:option] == "sheet"
      extract_skills
      Record.scrape(@skills)
    elsif record_params[:option] == "file"
      Record.import(record_params[:file])
    end
    redirect_to records_path
  end

  def index
    @record = Record.new
    $records = Job.filter(params[:search]).reverse
  end

  def export
    send_data Record.export_to_csv($records), filename: "records-#{Date.today}.csv"
  end

  private

  def record_params
    record_params = params.fetch(:record, {}).permit(:skills, :option)
    record_params[:skills] = record_params[:skills].split(",") if record_params[:skills].present?

    record_params
  end

  def extract_skills
    spreadsheet_id  = ENV['SPREADSHEET_ID']
    range           = ENV['RANGE']

    service         = GoogleSheetsService.service
    response        = service.get_spreadsheet_values spreadsheet_id, range

    @skills         = response.values.map{|v| v[1].gsub(" ","").split(",")}.flatten.uniq
  end

end
