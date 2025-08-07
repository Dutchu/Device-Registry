class Device < ApplicationRecord
  belongs_to :user, optional: true
  serialize :previous_owner_ids, coder: JSON, type: Array

  after_initialize :set_defaults

  private

  def set_defaults
    self.previous_owner_ids ||= []
  end
end
