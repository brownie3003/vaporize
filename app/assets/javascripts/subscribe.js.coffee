# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    user =
        subscription: "20"

    # Return true if all questions have been answered.
    signupComplete = ->
        user.subscription != undefined && user.flavor != undefined && user.cigarette != undefined

    discountPrice = (price) ->
        (parseInt(price) * 3 * 0.9).toFixed(2)

    showSubscription = ->
        threeMonthPrice = parseInt(user.subscription) * 3
        $(".offer").removeClass("hidden")
        $(".one-month").find(".price").html("£" + user.subscription + "/month")
        $(".three-months").find(".price").html("£" + threeMonthPrice + " upfront payment" )
        if user.cigarette == "true"
            $(".one-month").find(".price").append(" + £42.99 for the e-cigarette kit")
            $(".discount").html("If you sign up for 3 months in advance, the e-cigarette kit will be free")
        else
            discountedPrice = discountPrice(user.subscription)
            $(".three-months").find(".price").html("£" + discountedPrice + " upfront payment")
            $(".discount").html("Get 10% off if you sign up for 3 months")



    $('.subscription').on 'change', ->
        user.subscription = $('.subscription').val()
        showSubscription() if signupComplete()

    $('.flavor').on 'change', ->
        user.flavor = $('input:radio[name = "flavor"]:checked').val()
        showSubscription() if signupComplete()

    $('.cigarette').on 'change', ->
        user.cigarette = $('input:radio[name = "cigarette"]:checked').val()
        showSubscription() if signupComplete()


