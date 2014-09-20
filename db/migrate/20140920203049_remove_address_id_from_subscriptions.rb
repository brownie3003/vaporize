class RemoveAddressIdFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :address_id, :integer
  end
end
