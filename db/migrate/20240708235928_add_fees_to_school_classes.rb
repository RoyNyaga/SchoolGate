class AddFeesToSchoolClasses < ActiveRecord::Migration[7.1]
  def change
    add_column :school_classes, :required_fee, :integer
  end
end
