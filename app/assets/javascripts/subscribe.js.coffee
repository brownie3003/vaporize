# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    # User object
    user =
        subscription:
            value: undefined,
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
        threeMonthPrice = parseInt(user.subscription) * 3
        $("#offer").removeClass("hidden")
        $('html, body').animate({
            scrollTop: $("#offer").offset().top
        }, 1000);
        $(".one-month").find(".price").html("£" + user.subscription + "/month")
        $(".three-months").find(".price").html("£" + threeMonthPrice + " upfront payment" )
        if user.cigarette == "true"
            $(".one-month").find(".price").append(" + £42 for the e-cigarette kit")
            $(".discount").html("If you sign up for 3 months in advance, the e-cigarette kit will be free")
        else
            discountedPrice = discountPrice(user.subscription)
            $(".three-months").find(".price").html("£" + discountedPrice + " upfront payment")
            $(".discount").html("Get 10% off if you sign up for 3 months")

    moveToNextQuestion = (next) ->
        $('html, body').animate({
            scrollTop: $(next).offset().top
        }, 1000);

    showNavigationArrows = ->
        $(".prev-question, .next-question").delay(1000).fadeIn(500)

    # Hide stuff on load
    $(".prev-question, .next-question, #subscriptionLevel, .e-liquid-box-4, .e-liquid-box-5").hide()
    $("#showMeTheMoney").attr("disabled", true)

    ### Listeners ###
    $('#subscription').on 'change', (e) ->
        # Do you have an e-cigarette?
        if $(e.target).data('question') == 'e-cigarette'
            cigaretteValue = $('input:radio[name = "e-cigarette"]:checked').val()

            # Assign cigarette choice to user object
            if cigaretteValue == "true"
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
            user.subscription.value =  parseInt($('.subscription').val())
            # TODO empty the flavours object to avoid allowing them to submit a strange set of flavours
            $("#showMeTheMoney").attr("disabled", true)
            # Get bottle number from subscription value. Horrible way to do it, but here's the mapping
            if user.subscription.value == 12
                user.subscription.bottles = 3
                $(".e-liquid-box-4, .e-liquid-box-5").hide()
                $(".e-liquid-box-3").show()
            else if user.subscription.value == 15
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

