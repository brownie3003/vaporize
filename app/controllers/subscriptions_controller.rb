class SubscriptionsController < ApplicationController
	def new
		@subscription = Subscription.new
        session[:eliquids] = params[:eliquids]
        session[:subscription_plan] = params[:subscription_plan]
	end

	def create
		@subscription = Subscription.new(subscription_params)
        session[:eliquids].each do |id|
            @subscription.subscription_choices.build(eliquid: Eliquid.find(id))
        end
	    @subscription.subscription_plan = SubscriptionPlan.find(session[:subscription_plan])
        if @subscription.save
            redirect @subscription
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
				]
			)
		end
end
