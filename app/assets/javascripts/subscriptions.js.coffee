# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Box will only be visible on page load if we are editing a subscription, not signing up.

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
		$(".cigarette-offer").html("")
		$(".pricing-explanation").html("You will simply pay £" + user.price + " per
											month for your e-liquid. It will be delivered through your letter box on
											the day you choose.")

# Checks whether the number of flavours required by the subscription have been picked
allFlavoursPicked = (numberOfBottles) ->
	bottles = $(".e-liquid-box-" + numberOfBottles)
	for bottle in bottles
		if $(bottle).find("select").val() == ""
			return false
	$("#signUpTip").addClass("hidden")
	return true

# Setup flavour picker for the correct number of bottles
setupFlavourPicker = (numberOfBottles) ->
	subscriptionId = $(".e-liquid-bottle").find("select").attr("id")
	eLiquidBottle = $('.e-liquid-bottle')
	eLiquidBottle.find('select').attr('id', subscriptionId + "1")

	for i in [2..numberOfBottles]
		clone = eLiquidBottle.clone()
		clone.find('select').attr('id', subscriptionId + i)
		if numberOfBottles == 4
			$(".e-liquid-bottle").removeClass("col-sm-4").addClass("col-sm-3")
		if numberOfBottles == 5
			if i == 4
				clone.removeClass('col-sm-4').addClass('col-sm-4 col-sm-offset-2')
		clone.appendTo('#subscriptionBox')

showFlavourPicker = () ->
	$('#boxContent').removeClass('hidden')

# Fill flavours with set picks
autoPickFlavours = (numberOfBottles) ->
	# Get all the bottles in our specified box, e.g. 3, 4, 5
	bottles = $(".e-liquid-box-" + numberOfBottles)

	# For each bottle we're going to set the value of the select on the ID 'algorith' ;-)
	# 1 = tabacco, 2 = menthol, 3 = blueberry (liable to change)
	for i in [1..numberOfBottles]
		if i >= 4
			$('#subscription_choices_' + i).val(1)
		else
			$('#subscription_choices_' + i).val(i)

resetFlavoursPicker = ->
	eLiquidBottle = $('.e-liquid-bottle').first()

	$("#preSelectedBottles").addClass("hidden")
	$("#boxContent").addClass("hidden")
	$("#flavoursTip").removeClass("hidden")

	$('.e-liquid-bottle').remove()
	eLiquidBottle.appendTo('#subscriptionBox')
	eLiquidBottle.find('select').attr('id', 'subscription_choices_')
	if eLiquidBottle.hasClass('col-sm-3')
		eLiquidBottle.removeClass('col-sm-3').addClass('col-sm-4')

#if $('#subscriptionBox').is(':visible')
#	user.bottles = $('.subscription-plan-select').find(':selected').data('bottles')
#	console.log(user.bottles)
#	setupFlavourPicker(user.bottles)
	


$ ->

	fullPage = $("#fullPage")

	fullPage.fullpage
		verticalCentered: true
		resize: false
		css3: true
		autoScrolling: false
	### Hide stuff on load ###
	$("#showMeTheMoney, #signUpButton").attr("disabled", true)

	### Listeners ###

	# When anything changes on the sign up form.
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
			
			$('#showMeTheMoney').attr('disabled', false)

			# TODO be less shit.
			# Because of hackery, rails will only pull out the second select
			# for subscription plan, as ids should be unique, this will
			# make sure both selects have the same value for form submission
			$(".subscription-plan-select").val($(e.target).val())

			user.price = $(e.target).find(':selected').data('price')
			user.bottles =  $(e.target).find(':selected').data('bottles')

			$("#flavours").removeClass("hidden")
			$("#flavoursTip").addClass("hidden")
			$(".subscription-offer").addClass("hidden")
			
			setupFlavourPicker(user.bottles)

			if user.ecigarette == "true"
				$("#preSelectedBottles").removeClass("hidden")
				$("#bottleCount").text(user.bottles + "x10ml bottles")
				autoPickFlavours(user.bottles)
				$("#showMeTheMoney").attr("disabled", false)
			else #Show the flavour picker.
				$("#boxContent").removeClass("hidden")
				showFlavourPicker()

			$.fn.fullpage.moveSectionDown()

		if $(e.target).attr('name') == "subscription_choices[]"
			if allFlavoursPicked(user.bottles)
				$("#showMeTheMoney").attr("disabled", false)

	$("#letMePick").on 'click', ->
		$("#preSelectedBottles").addClass("hidden")
		$("#boxContent").removeClass("hidden")
		showFlavourPicker()

	$("#showMeTheMoney").on 'click', (e) ->
		e.preventDefault()
		$(".subscription-offer").removeClass("hidden")
		$("#signUpButton").attr("disabled", false)
		$("#signUpTip").addClass("hidden")
		showSubscription()
		$.fn.fullpage.moveSectionDown()

	$("#signUpButton, #enterAddress, #selectShippingDay, #enterCardDetails").on 'click', (e) ->
		e.preventDefault()
		$.fn.fullpage.moveSectionDown()



	$('#subscriptionEditForm').on 'load', (e) ->
		console.log("yellow")
