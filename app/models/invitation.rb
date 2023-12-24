class Invitation < ApplicationRecord
  belongs_to :sent_by
  belongs_to :teacher
  belongs_to :school_id
end
