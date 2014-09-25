class SubscriptionsController < ApplicationController
	def new
		@subscription = Subscription.new
	end

	def create
		@subscription = Subscription.new(subscription_params)
		if @subscription.save
			puts "YAY"
			# Redirect to show
		else
			puts "NAY"
			render 'new'
		end
	end

	def edit
	end

	private
		def subscription_params
			params.require(:subscription).permit(
				:first_name,
				:last_name,
				:email,
				:subscription_plan_id,
				:shipping_day,
				address_attributes: [
					:house_number,
					:street,
					:second_line,
					:city,
					:county,
					:postcode
				],
				subscription_choice_attributes: [
					:subscription_id,
					:eliquid_id
				]
			)
		end
end