class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def two_names
    full_name.split(" ")[0..1].join(" ")
  end

  def self.ransackable_attributes(auth_object = nil) # this method is to avoid errors on active admin dashboard
    self.attribute_names
  end

  private

  def set_full_name
    self.full_name = first_name + " " + last_name
  end
end
