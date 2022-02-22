class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.decimal :cost_to_company

      t.timestamps
    end
  end
end
