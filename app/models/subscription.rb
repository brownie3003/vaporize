class Subscription < ActiveRecord::Base
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	after_create :create_stripe_customer
	after_update :check_subscription_change
	before_destroy :delete_stripe_customer

	# TODO add validations
	# Can't validate against subscription_choices because view has loads of
	# blank ones, so deal with thos in controller

	validates :first_name, :last_name, :email, :subscription_plan_id, :shipping_day, presence: true
	validates :email, 	presence: true,
			  			uniqueness: true,
			  			format: { with: VALID_EMAIL_REGEX }

	has_many :subscription_choices
	has_many :eliquids, through: :subscription_choices
	has_one :address
	belongs_to :subscription_plan

	accepts_nested_attributes_for :address, allow_destroy: true
	# :subscription_choices currently not required because not nesting
	# in view: subscriptions/new.html.slim
	# accepts_nested_attributes_for :subscription_choices, allow_destroy: true

	def create_stripe_customer
		customer = Stripe::Customer.create(
				card: stripe_token,
				email: email
		)

		self.stripe_customer_id = customer.id

		if initial_ecigarette
			Stripe::InvoiceItem.create(
				customer: customer,
				amount: 2500,
				currency: "gbp",
				description: "E-cigarette kit"
			)
		end

		subscription = customer.subscriptions.create(plan: self.subscription_plan.stripe_plan_id)
		self.stripe_subscription_id = subscription.id

		save!

		send_signup_confirmation
	end
	
	def check_subscription_change
		customer = get_stripe_customer
		subscription = customer.subscriptions.retrieve(self.stripe_subscription_id)
		if subscription.plan.id.to_i != self.subscription_plan.stripe_plan_id
			change_subscription_plan(subscription)
		end
	end
	
	def change_subscription_plan(subscription)
		subscription.plan = self.subscription_plan.stripe_plan_id
		subscription.prorate = false
		subscription.save
	end
	
	def delete_stripe_customer
		customer = get_stripe_customer
		customer.delete
	end

	def send_signup_confirmation
		require 'mandrill'

		message = {
			to: [
					{
							email: self.email,
							name: self.first_name,
					}
			],
			important: false,
			track_opens: true,
			track_clicks: true,
			global_merge_vars: [
					{
							name: 'name',
							content: self.first_name
					}
			],
		}

		mandrill = Mandrill::API.new ENV['MANDRILL_API']
		sending = mandrill.messages.send_template('signup confirmation', [], message = message)
		
		Rails.logger.info sending
	end


	def check_postcode(subscription, postcode)
		if subscription.address.postcode === postcode
			return true
		end
		false
	end
	
	private
		def get_stripe_customer
			Stripe::Customer.retrieve(self.stripe_customer_id)
		end
end
