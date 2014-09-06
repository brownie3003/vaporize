# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    # Declare user object
    user =
        subscription:
            price: undefined,
            bottles: undefined,
            flavours:
                1: undefined
        cigarette: true

    ### Functions ###

    # Return true if all questions have been answered.
    signupComplete = ->
        user.subscription != undefined && user.cigarette != undefined

    discountPrice = (price) ->
        (parseInt(price) * 3 * 0.9).toFixed(2)

    showSubscription = ->
        discountPrice = calculateDiscountPrice()
        showOneMonth()
        showThreeMonth(discountPrice)
        $("#offer").removeClass("hidden")
        $('html, body').animate({
            scrollTop: $("#offer").offset().top
        }, 1000);

    calculateDiscountPrice = ->
        if user.cigarette == true
            return (user.subscription.price)*3
        else
            return ((user.subscription.price) * 3 * 0.8).toFixed(2)

    showOneMonth = ->
        $(".one-month").find(".price").html("£" + user.subscription.price + "/month")
        if user.cigarette == true
            $(".one-month").find(".cigarette-offer").html("£45 for the e-cigarette kit")
            $(".one-month").find(".pricing-explanation").html("Your first payment will be £" + (user.subscription.price + 45) +
                " to pay for your e-cigarette kit. After this you will pay £" + user.subscription.price + " per month.");
        else
            $(".one-month").find(".pricing-explanation").html("You will simply pay £" + user.subscription.price + " per month
                for your e-liquid.")

    showThreeMonth = (discountPrice) ->
        if user.cigarette == true
            $(".three-months").find(".price").html("£" + (user.subscription.price)*3)
            $(".three-months").find(".cigarette-offer").html("£20 for the e-cigarette kit")
            $(".three-months").find(".pricing-explanation").html("Your first payment will be £" +
                    ((user.subscription.price)*3 + 20) + " which includes your first 3 months subscription plus £20 for your
                e-cigarette kit. After 3 months this you will pay £" +
                user.subscription.price + " per month.");
        else
            $(".three-months").find(".price").html("£" + discountPrice)
            $(".three-months").find(".pricing-explanation").html("Your first payment will be £" + discountPrice +
                ". We've given you 20% off your normal subscription price of £" + user.subscription.price + ". After 3
                months you will be charged £" + user.subscription.price + " per month." )

    moveToNextQuestion = (next) ->
        $('html, body').animate({
            scrollTop: $(next).offset().top
        }, 1000);

    showNavigationArrows = ->
        $(".prev-question, .next-question").delay(1000).fadeIn(500)

    ### Hide stuff on load ###
    $(".prev-question, .next-question, #subscriptionLevel, .e-liquid-box-4, .e-liquid-box-5").hide()
    $("#showMeTheMoney").attr("disabled", true)

    ### Listeners ###

    # When anything changes on the form.
    $('#subscription').on 'change', (e) ->
        # Do you have an e-cigarette?
        if $(e.target).data('question') == 'e-cigarette'
            cigaretteprice = $('input:radio[name = "e-cigarette"]:checked').val()

            # Assign cigarette choice to user object
            if cigaretteprice == "true"
                user.cigarette = true
                $("#subscriptionLevel").hide()
                $("#dailyCigarettes").show()
            else
                user.cigarette = false
                $("#dailyCigarettes").hide()
                $("#subscriptionLevel").show()

            moveToNextQuestion('#eLiquid')

        # How much e-liquid do you want?
        if $(e.target).data('question') == 'subscription level'
            user.subscription.price =  parseInt($(e.target).val())
            # empty the flavours object to avoid allowing user to submit a strange set of flavours
            user.subscription.flavours = 1: undefined
            $("#showMeTheMoney").attr("disabled", true)
            # Get bottle number from subscription price. Horrible way to do it, but here's the mapping
            if user.subscription.price == 12
                user.subscription.bottles = 3
                $(".e-liquid-box-4, .e-liquid-box-5").hide()
                $(".e-liquid-box-3").show()
            else if user.subscription.price == 15
                user.subscription.bottles = 4
                $(".e-liquid-box-3, .e-liquid-box-5").hide()
                $(".e-liquid-box-4").show()
            else
                user.subscription.bottles = 5
                $(".e-liquid-box-3, .e-liquid-box-4").hide()
                $(".e-liquid-box-5").show()
            moveToNextQuestion('#flavours')

        if $(e.target).data('question') == "flavour"
            pickNumber = $(e.target).attr("id").split("-")[1]
            user.subscription.flavours[pickNumber] = $(e.target).val()
            if Object.keys(user.subscription.flavours).length == user.subscription.bottles && user.subscription.flavours[1] != undefined
                $("#showMeTheMoney").attr("disabled", false)

        showNavigationArrows()

    $(".prev-question").on 'click', (e) ->
        e.preventDefault()
        currentQuestion = $(e.target).parents(".row").attr("id")

        if currentQuestion == "eLiquid"
            moveToNextQuestion("#eCigarette")
        else if currentQuestion == "flavours"
            moveToNextQuestion("#eLiquid")
        else if currentQuestion == "offer"
            moveToNextQuestion("#flavours")

    $(".next-question").on 'click', (e) ->
        currentQuestion = $(e.target).parents(".row").attr("id")

        if currentQuestion == "eCigarette"
            moveToNextQuestion("#eLiquid")
        else if currentQuestion == "eLiquid"
            moveToNextQuestion("#flavours")

    $("#showMeTheMoney").on 'click', (e) ->
        e.preventDefault()
        showSubscription() if signupComplete()

