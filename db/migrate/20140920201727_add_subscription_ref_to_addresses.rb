class AddSubscriptionRefToAddresses < ActiveRecord::Migration
  def change
    add_reference :addresses, :subscription, index: true
  end
end
