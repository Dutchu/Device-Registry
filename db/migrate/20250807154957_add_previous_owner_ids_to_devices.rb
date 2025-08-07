class AddPreviousOwnerIdsToDevices < ActiveRecord::Migration[7.1]
  def change
    add_column :devices, :previous_owner_ids, :text
  end
end
