class RemoveScaleFromSkillSalary2 < ActiveRecord::Migration[6.1]
  def change
    change_column :skills, :min , :decimal, precision: 10, scale: 2
    change_column :skills, :max , :decimal, precision: 10, scale: 2
  end
end
