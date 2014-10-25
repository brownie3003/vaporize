# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
	fullPage = $("#fullPage")
	if fullPage.length
		fullPage.fullpage
			verticalCentered: true
			resize: false
			css3: true
			autoScrolling: false

	# Handy little object for tracking important variables from the model
	user = {}

	### Functions ###

	showSubscription = ->
		$(".price").html("£" + user.price + "/month")
		if user.ecigarette == "true"
			$(".cigarette-offer").html("£25 for the e-cigarette kit")
			$(".pricing-explanation").html("Your first payment will be £" +
					(user.price + 25) + " to pay for your e-cigarette kit. After this you will pay £" +
					user.price + " per month.");
		else
			$(".pricing-explanation").html("You will simply pay £" + user.price + " per
											month for your e-liquid. It will be delivered through your letter box on
											the day you choose.")

	# Checks whether the number of flavours required by the subscription have been picked
	allFlavoursPicked = (numberOfBottles) ->
		bottles = $(".e-liquid-box-" + numberOfBottles)
		for bottle in bottles
			if $(bottle).find("select").val() == ""
				return false
		$("#signUpButtonTip").addClass("hidden")
		return true

	# Show the flavour picker for the correct number of bottles
	showFlavourPicker = (numberOfBottles) ->
		for i in [3..5]
			if i == numberOfBottles
				$(".e-liquid-box-" + i).removeClass("hidden")
			else
				$(".e-liquid-box-" + i).addClass("hidden")

	# Fill flavours with set picks
	autoPickFlavours = (numberOfBottles) ->
		# Get all the bottles in our specified box, e.g. 3, 4, 5
		bottles = $(".e-liquid-box-" + numberOfBottles)

		# For each bottle we're going to set the value of the select
		# Key:
		# 1 = tabacco, 2 = menthol, 3 = blueberry (liable to change)
		# Very hacky but quick
		for bottle, index in bottles
			switch index
				when 0 then $(bottle).find("select").val("1")
				when 1 then $(bottle).find("select").val("2")
				when 2 then $(bottle).find("select").val("3")
				when 3 then $(bottle).find("select").val("1")
				when 4 then $(bottle).find("select").val("3")

	resetFlavoursPicker = ->
		$("#preSelectedBottles").addClass("hidden")
		$("#boxContent, [class*='e-liquid-box-']").addClass("hidden")
		$("#flavoursTip").removeClass("hidden")

		# Will clear any selected option ensuring we get the correct options
		# submitted to our controller
		$(".flavour-select").children().removeAttr("selected")

	### Hide stuff on load ###
	$("#showMeTheMoney, #signUpButton").attr("disabled", true)

	### Listeners ###

	# When anything changes on the form.
	$('#subscriptionForm').on 'change', (e) ->
		# We will check and enable this button if everything is correct at each change
		$("#showMeTheMoney").attr("disabled", true)
		# Do you have an e-cigarette?
		if $(e.target).attr('name') == 'subscription[initial_ecigarette]'
			resetFlavoursPicker()

			user.ecigarette = $('input:radio[name = "subscription[initial_ecigarette]"]:checked').val()

			$("#quantityTip").addClass("hidden")
			$(".subscription-offer").addClass("hidden")

			# Will clear any selected subscription plan ensuring we get the
			# correct plan submitted to our controller
			$(".subscription-plan-select").children().removeAttr("selected")

			# Assign cigarette choice to user object
			if user.ecigarette == "true"
				$("#subscriptionLevel").addClass("hidden")
				$("#dailyCigarettes").removeClass("hidden")
			else
				$("#dailyCigarettes").addClass("hidden")
				$("#subscriptionLevel").removeClass("hidden")

			$.fn.fullpage.moveSectionDown()

		# How much e-liquid do you want?
		if $(e.target).attr('name') == "subscription[subscription_plan_id]"
			resetFlavoursPicker()

			user.price = $(e.target).find(':selected').data('price')
			user.bottles =  $(e.target).find(':selected').data('bottles')

			$("#flavours").removeClass("hidden")
			$("#flavoursTip").addClass("hidden")
			$(".subscription-offer").addClass("hidden")
			$("#showMeTheMoney").attr("disabled", true)

			if user.ecigarette == "true"
				$("#preSelectedBottles").removeClass("hidden")
				$("#bottleCount").text(user.bottles + "x10ml bottles")
				autoPickFlavours(user.bottles)
				$("#showMeTheMoney").attr("disabled", false)
			else #Show the flavour picker.
				$("#boxContent").removeClass("hidden")
				showFlavourPicker(user.bottles)

			$.fn.fullpage.moveSectionDown()

		if $(e.target).attr('name') == "subscription_choices[]"
			if allFlavoursPicked(user.bottles)
				$("#showMeTheMoney").attr("disabled", false)

	$("#letMePick").on 'click', ->
		$("#preSelectedBottles").addClass("hidden")
		$("#boxContent").removeClass("hidden")
		showFlavourPicker(user.bottles)

	$("#showMeTheMoney").on 'click', (e) ->
		e.preventDefault()
		$(".subscription-offer").removeClass("hidden")
		$("#signUpButton").attr("disabled", false)
		showSubscription()
		$.fn.fullpage.moveSectionDown()

	$("#signUpButton").on 'click', (e) ->
		e.preventDefault()
		$.fn.fullpage.moveSectionDown()
