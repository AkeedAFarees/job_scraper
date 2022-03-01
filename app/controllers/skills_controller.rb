class SkillsController < ApplicationController
  before_action :set_skill, only: %i[ show edit update destroy cancel_update ]

  # GET /skills or /skills.json
  def index
    @skill = Skill.new
    $skills = Skill.filter(params[:search]).reverse
    @skills = Kaminari.paginate_array($skills).page(params[:page]).per(Kaminari.config.default_per_page)
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills or /skills.json
  def create
    @skill = Skill.new(skill_params)
    @skill.save!
  end

  # PATCH/PUT /skills/1 or /skills/1.json
  def update
    @skill.update!(skill_params)
  end

  # DELETE /skills/1 or /skills/1.json
  def destroy
    @skill.destroy!
  end

  def calculate_form
    @skills = Skill.all
  end

  def calculate
    $cost_to_company = Setting.last.cost_to_company

    @skill = Skill.find_by(name: skill_params[:name], experience: skill_params[:experience])
    @total = @skill.present? ? @skill.max + $cost_to_company : nil
  end

  def update_experience
    @skills = Skill.where("LOWER(name) = ?", params[:name].downcase)
  end

  def cancel_update

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def skill_params
      params.fetch(:skill, {}).permit(:name, :min, :max, :experience)
    end
end
