jQuery ($) ->
	$("#subscriptionForm").submit (event) ->
		$form = $(this)
	
		# Disable the submit button to prevent repeated clicks
		$form.find("input[type='submit']").prop "disabled", true
		Stripe.setPublishableKey('pk_test_pLDgmguQNCcVdl40qgCxWfke')
		Stripe.card.createToken $form, stripeResponseHandler
		
		# Prevent the form from submitting with the default action
		false
	
	stripeResponseHandler = (status, response) ->
		$form = $("#subscriptionForm")
		
		if response.error
			# Show the errors on the form
			$form.find(".payment-errors").text response.error.message
			$form.find("input[type='submit']").prop "disabled", false
		else
			# response contains id and card, which contains additional card details
			token = response.id
	
			# Insert the token into the form so it gets submitted to the server
			$form.append $("<input type=\"hidden\" name=\"stripeToken\" />").val(token)
	
			# and submit
			$form.get(0).submit()