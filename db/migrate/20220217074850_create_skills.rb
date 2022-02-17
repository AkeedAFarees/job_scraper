class CreateSkills < ActiveRecord::Migration[6.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.decimal :min, precision: 5, scale: 2
      t.decimal :max, precision: 5, scale: 2
      t.string :experience

      t.timestamps
    end
  end
end
