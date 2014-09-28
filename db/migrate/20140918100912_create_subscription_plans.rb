class CreateSubscriptionPlans < ActiveRecord::Migration
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.integer :eliquid_count
      t.integer :interval_cost
      t.string :interval
      t.integer :initial_cost
      t.integer :initial_interval_count
      t.integer :ecigarette_cost

      t.timestamps
    end
  end
end
