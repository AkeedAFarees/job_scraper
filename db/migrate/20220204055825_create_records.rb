class CreateRecords < ActiveRecord::Migration[6.1]
  def change
    create_table :records do |t|
      t.string :dev_name
      t.string :skills, array:true, default: []
      t.timestamps
    end
  end
end
