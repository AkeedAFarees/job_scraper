class SettingsController < ApplicationController
  before_action :set_setting, only: %i[ edit update ]

  # GET /settings/1/edit
  def edit
  end

  # PATCH/PUT /settings/1 or /settings/1.json
  def update
    if @setting.update(setting_params)
      redirect_to edit_setting_path(@setting)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def setting_params
      params.fetch(:setting, {}).permit(:id, :cost_to_company)
    end
end
