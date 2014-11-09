class SessionsController < ApplicationController
	def new
	end
	
	def create
		subscription = Subscription.find_by(email: params[:session][:email])
		if subscription && subscription.check_postcode(subscription, params[:session][:postcode])
			log_in subscription
			redirect_to subscription
			
		else
			flash.now[:danger] = 'Invalid email/postcode combination'
			render 'new'
		end
	end
	
	def destroy
		log_out
		redirect_to root_url
	end
	
end
