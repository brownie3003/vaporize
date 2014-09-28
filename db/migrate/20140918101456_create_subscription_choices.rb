class CreateSubscriptionChoices < ActiveRecord::Migration
  def change
    create_table :subscription_choices do |t|
      t.integer :subscription_id
      t.integer :eliquid_id

      t.timestamps
    end
  end
end
