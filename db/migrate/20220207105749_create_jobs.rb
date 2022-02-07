class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :company
      t.string :link
      t.datetime :published_date
      t.string :published_type
      t.string :revenue
      t.string :revenue_period
      t.string :skill

      t.timestamps
    end
  end
end
