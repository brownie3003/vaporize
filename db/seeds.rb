# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create some Eliquids
Eliquid.create(name: "Tabacco", volume: "10ml")
Eliquid.create(name: "Menthol", volume: "10ml")
Eliquid.create(name: "Blueberry", volume: "10ml")

# Create some Subscription Plans
SubscriptionPlan.create(name: "3X", eliquid_count: 3, interval_cost: 12, interval: "monthly", initial_cost: 0, initial_interval_count: 0, ecigarette_cost: 25, bottle_count_description: "3x10ml", equivalent_cigarettes_description: "Less than 10 cigarettes")
# SubscriptionPlan.create(name: "3X UPFRONT", eliquid_count: 3, interval_cost: 12, interval: "monthly", initial_cost: 36, initial_interval_count: 3, ecigarette_cost: 0)
SubscriptionPlan.create(name: "4X", eliquid_count: 4, interval_cost: 15, interval: "monthly", initial_cost: 0, initial_interval_count: 0, ecigarette_cost: 25, bottle_count_description: "4x10ml", equivalent_cigarettes_description: "Between 10 and 20 cigarettes")
# SubscriptionPlan.create(name: "4X UPFRONT", eliquid_count: 4, interval_cost: 15, interval: "monthly", initial_cost: 45, initial_interval_count: 3, ecigarette_cost: 0)
SubscriptionPlan.create(name: "5X", eliquid_count: 5, interval_cost: 18, interval: "monthly", initial_cost: 0, initial_interval_count: 0, ecigarette_cost: 25, bottle_count_description: "5x10ml", equivalent_cigarettes_description: "More than 20 cigarettes")
# SubscriptionPlan.create(name: "5X UPFRONT", eliquid_count: 5, interval_cost: 18, interval: "monthly", initial_cost: 54, initial_interval_count: 3, ecigarette_cost: 0)
