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

  def format_phone_number
    if phone_number.length == 9
      return "237" + phone_number
    end
    return phone_number
  end

  private

  def set_full_name
    self.full_name = first_name + " " + last_name
  end

  def set_phone_number
    self.phone_number = format_phone_number
  end

  def phone_number_digits_validation
    errors.add(:phone_number, "Must be 9 digits.") if self.phone_number.length != 12
  end
end
