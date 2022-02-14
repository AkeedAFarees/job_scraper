class CreateJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :jobs do |t|
      t.string :cv_job_id
      t.string :title
      t.string :company_id
      t.string :company
      t.string :link
      t.datetime :published_date
      t.string :published_type
      t.datetime :renewed_date
      t.string :revenue
      t.string :revenue_period
      t.string :skill

      t.timestamps
    end
  end
end
