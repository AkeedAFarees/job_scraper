class RecordsController < ApplicationController

  def new
    @record = Record.new
  end

  def create
    if params[:record][:skills].present?
      Record.scrape(params[:record][:skills])
      puts "!!!!!!!!!!!!!!!!!!!!!!!"
    else
      Record.import(params[:record][:file])
      puts "&&&&&&&&&&&&&&&&&&&&&&&"
      # flash[:notice] = "Records uploaded successfully"
    end
    redirect_to records_path
  end
end
