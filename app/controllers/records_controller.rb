class RecordsController < ApplicationController

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
  end

  private

  def record_params
    record_params = params.fetch(:record, {}).permit(:skills)
    record_params[:skills] = record_params[:skills].split(",") if record_params[:skills].present?

    record_params
  end

end
