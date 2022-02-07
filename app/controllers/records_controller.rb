class RecordsController < ApplicationController

  def new
    @record = Record.new
  end

  def create
    if params[:record][:skills].present?
      Record.scrape(params[:record][:skills])
    else
      Record.import(params[:record][:file])
      # flash[:notice] = "Records uploaded successfully"
    end
    redirect_to records_path
  end
end
