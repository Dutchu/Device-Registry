class Device < ApplicationRecord
  belongs_to :user, optional: true
  serialize :previous_owner_ids, Array
end
