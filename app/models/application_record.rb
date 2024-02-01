class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  private

  def set_full_name
    self.full_name = first_name + " " + last_name
  end
end
