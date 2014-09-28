class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :shipping_day
      t.string :email
      t.string :first_name
      t.string :last_name
      t.boolean :initial_ecigarette
      t.string :stripe_token
      t.integer :address_id
      t.integer :subscription_plan_id

      t.timestamps
    end
  end
end
