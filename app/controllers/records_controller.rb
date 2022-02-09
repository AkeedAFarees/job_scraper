class RecordsController < ApplicationController
  require "google_sheets_service"

  before_action :extract_skills, only: :index

  def new
    @record = Record.new
  end

  def create
    if record_params[:skills].present?
      Record.scrape(record_params[:skills])
    else
      Record.import(record_params[:file])
      # flash[:notice] = "Records uploaded successfully"
    end
    redirect_to records_path
  end

  def index
    @record = Record.new
    @records = Job.filter(params[:search])

    Record.scrape(@skills)
  end

  private

  def record_params
    record_params = params.fetch(:record, {}).permit(:skills)
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
