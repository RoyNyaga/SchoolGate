class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def two_names
    full_name.split(" ")[0..1].join(" ")
  end

  private

  def set_full_name
    self.full_name = first_name + " " + last_name
  end
end
