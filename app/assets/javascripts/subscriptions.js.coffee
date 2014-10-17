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
			navigation: true

	# Declare user object
	user =
		subscription:
			price: undefined,
			bottles: undefined,
			flavours:
				1: undefined
		cigarette: true

	### Functions ###

	# Return true if all questions have been answered and the user object is complete
	signupComplete = ->
		user.cigarette != undefined && user.subscription.price != undefined && allFlavoursPicked()

	showSubscription = ->
		$(".one-month").find(".price").html("£" + user.subscription.price + "/month")
		if user.cigarette == true
			$(".one-month").find(".cigarette-offer").html("£25 for the e-cigarette kit")
			$(".one-month").find(".pricing-explanation").html("Your first payment will be £" +
					(user.subscription.price + 25) + " to pay for your e-cigarette kit. After this you will pay £" +
					user.subscription.price + " per month.");
		else
			$(".one-month").find(".pricing-explanation").html("You will simply pay £" + user.subscription.price + " per month
						                      for your e-liquid.")
		$.fn.fullpage.moveSectionDown()

	# Checks whether the number of flavours required by the subscription have been picked
	allFlavoursPicked = ->
		flavoursCount = user.subscription.bottles
		for i in [1..flavoursCount]
			if user.subscription.flavours[i] == undefined
				return false
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
		user.subscription.flavours[1] = "tabacco"
		user.subscription.flavours[2] = "menthol"
		user.subscription.flavours[3] = "blueberry"
		if numberOfBottles == 5
			user.subscription.flavours[4] = "tabacco"
			user.subscription.flavours[5] = "apple"
		if numberOfBottles == 4
			user.subscription.flavours[4] = "tabacco"

	resetFlavoursPicker = ->
		$("#preSelectedBottles").addClass("hidden")
		$("#boxContent, [class*='e-liquid-box-']").addClass("hidden")

	### Hide stuff on load ###
	$("#showMeTheMoney, #pay").attr("disabled", true)

	### Listeners ###

	# When anything changes on the form.
	$('#subscription').on 'change', (e) ->
		# We will check and enable this button if everything is correct at each change
		$("#showMeTheMoney").attr("disabled", true)
		# Do you have an e-cigarette?
		if $(e.target).data('question') == 'e-cigarette'
			cigaretteprice = $('input:radio[name = "e-cigarette"]:checked').val()

			$("#quantityTip").addClass("hidden")
			$(".subscription-offer").addClass("hidden")

			resetFlavoursPicker()

			# Assign cigarette choice to user object
			if cigaretteprice == "true"
				user.cigarette = true
				$("#subscriptionLevel").addClass("hidden")
				$("#dailyCigarettes").removeClass("hidden")
			else
				user.cigarette = false
				$("#dailyCigarettes").addClass("hidden")
				$("#subscriptionLevel").removeClass("hidden")

			$("#eLiquid").removeClass("hidden")
			$.fn.fullpage.moveSectionDown()

		# How much e-liquid do you want?
		if $(e.target).data('question') == 'subscription level'
			user.subscription.price =  parseInt($(e.target).val())
			$("#flavours").removeClass("hidden")

			$("#flavoursTip").addClass("hidden")

			$(".subscription-offer").addClass("hidden")

			resetFlavoursPicker()

			# Get bottle number from subscription price. Horrible way to do it, but here's the mapping
			if user.subscription.price == 12
				user.subscription.bottles = 3
			else if user.subscription.price == 15
				user.subscription.bottles = 4
			else
				user.subscription.bottles = 5

			# empty the flavours object to avoid allowing user to submit a strange set of flavours
			user.subscription.flavours = 1: undefined
			$("#showMeTheMoney").attr("disabled", true)

			if user.cigarette == true
				$("#preSelectedBottles").removeClass("hidden")
				$("#bottleCount").text(user.subscription.bottles + "x10ml bottles")
				autoPickFlavours(user.subscription.bottles)
			else #Show the flavour picker.
				$("#boxContent").removeClass("hidden")
				showFlavourPicker(user.subscription.bottles)

			$.fn.fullpage.moveSectionDown()

		if $(e.target).data('question') == "flavour"
			pickNumber = $(e.target).attr("id").split("-")[1]
			user.subscription.flavours[pickNumber] = $(e.target).val()

		if signupComplete()
			$("#showMeTheMoney").attr("disabled", false)

	$("#letMePick").on 'click', ->
		user.subscription.flavours = 1: undefined
		$("#showMeTheMoney, #pay").attr("disabled", true)
		$("#preSelectedBottles").addClass("hidden")
		$("#boxContent").removeClass("hidden")
		showFlavourPicker(user.subscription.bottles)

	$("#showMeTheMoney").on 'click', (e) ->
		e.preventDefault()
		$.fn.fullpage.moveSectionDown()
		$(".subscription-offer").removeClass("hidden")
		$("#pay").attr("disabled", false)
		showSubscription()

	$("#pay").on 'click', (e) ->
		e.preventDefault()
		$.ajax "/subscribe",
			type: "GET"
			dataType: "json"
			data: user
			complete: ->
				window.location.href = "/subscriptions/new" #Massive shitty hack
