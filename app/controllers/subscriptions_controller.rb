class SubscriptionsController < ApplicationController

	def show
	end

	def new
		puts params[:ecigarette]
		@subscription = Subscription.new
		@subscription.subscription_plan = SubscriptionPlan.find_by(interval_cost: session[:subscription_plan])
		@subscription.initial_ecigarette = session[:ecigarette]
		puts session[:eliquids]
	end

	def create
		puts session[:eliquids]
		@subscription = Subscription.new(subscription_params)
        session[:eliquids].each do |flavour|
            @subscription.subscription_choices.build(eliquid: Eliquid.find_by(name: flavour))
        end
	    @subscription.subscription_plan = SubscriptionPlan.find_by(interval_cost: session[:subscription_plan])
        if @subscription.save
            redirect_to @subscription
		else
			puts "NAY"
			render 'new'
		end
	end

	def edit
	end

	def newPlan
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
