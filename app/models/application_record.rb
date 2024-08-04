class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def two_names
    full_name.split(" ")[0..1].join(" ")
  end

  # this method is to avoid Ransack errors on active admin dashboard
  def self.ransackable_attributes(auth_object = nil)
    self.attribute_names
  end

  # this method is to avoid Ransack errors on active admin dashboard
  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def set_full_name
    self.full_name = first_name + " " + last_name
  end
end
