# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    user = {}

    # Hide these until user tells us whether they need an e-cigarette or not
    $("#subscriptionLevel").hide()
    $("#dailyCigarettes").hide()

    # Hide navigation arrows at the start
    $(".prev-question, .next-question").hide()

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

    $('#subscription').on 'change', (e) ->
        if $(e.target).data('question') == 'e-cigarette'
            cigaretteValue = $('input:radio[name = "e-cigarette"]:checked').val()

            #Assign cigarette choice to user object
            if cigaretteValue == "true"
                user.cigarette = true
                $("#subscriptionLevel").hide()
                $("#dailyCigarettes").show()
            else
                user.cigarette = false
                $("#dailyCigarettes").hide()
                $("#subscriptionLevel").show()

            moveToNextQuestion('#eLiquid')

        if $(e.target).data('question') == 'subscription level'
            user.subscription = $('.subscription').val()
            moveToNextQuestion('#flavours')

        showNavigationArrows()

    $("#showMeTheMoney").on 'click', (e) ->
        e.preventDefault()
        showSubscription() if signupComplete()

