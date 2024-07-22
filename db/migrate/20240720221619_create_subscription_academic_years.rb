class CreateSubscriptionAcademicYears < ActiveRecord::Migration[7.1]
  def change
    create_table :subscription_academic_years do |t|
      t.string :year
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
