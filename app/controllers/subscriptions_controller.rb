class SubscriptionsController < ApplicationController
	def new
		@subscription = Subscription.new
	end

	def create
		@subscription = Subscription.new(subscription_params)
		if @subscription.save
			puts "YAY"
		else
			puts "NAY"
		end
	end

	def edit
	end

	private
		def subscription_params
			params.require(:subscription).permit(:first_name, :last_name,
				:email, address_attributes: [:house_number, :street,
					:second_line, :city, :county, :postcode])
		end
end
