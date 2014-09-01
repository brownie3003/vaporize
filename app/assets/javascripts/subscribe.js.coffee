# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
    user =
        subscription: "20"

    # Hide navigation arrows at the start
    $(".prev-question, .next-question").hide()

    # Return true if all questions have been answered.
    signupComplete = ->
        user.subscription != undefined && user.flavor != undefined && user.cigarette != undefined

    discountPrice = (price) ->
        (parseInt(price) * 3 * 0.9).toFixed(2)

    showSubscription = ->
        threeMonthPrice = parseInt(user.subscription) * 3
        $("#offer").removeClass("hidden")
        $('html, body').animate({
            scrollTop: $("#offer").offset().top
        }, 500);
        $(".one-month").find(".price").html("£" + user.subscription + "/month")
        $(".three-months").find(".price").html("£" + threeMonthPrice + " upfront payment" )
        if user.cigarette == "true"
            $(".one-month").find(".price").append(" + £42.99 for the e-cigarette kit")
            $(".discount").html("If you sign up for 3 months in advance, the e-cigarette kit will be free")
        else
            discountedPrice = discountPrice(user.subscription)
            $(".three-months").find(".price").html("£" + discountedPrice + " upfront payment")
            $(".discount").html("Get 10% off if you sign up for 3 months")

    moveToNextQuestion = (currentQuestion) ->
        # Get id for next question
        nextQuestion = "#question-" + (currentQuestion + 1)
        $('html, body').animate({
            scrollTop: $(nextQuestion).offset().top
        }, 1000);

    showNavigationArrows = ->
        $(".prev-question, .next-question").delay(1000).fadeIn(500)

    $('#subscription').on 'change', (e) ->
        currentQuestion = $(e.target).data("question")
        user.subscription = $('.subscription').val()
        user.flavor = $('input:radio[name = "flavor"]:checked').val()
        user.cigarette = $('input:radio[name = "cigarette"]:checked').val()
        if currentQuestion != 3
            moveToNextQuestion(currentQuestion)
        showNavigationArrows()
        showSubscription() if signupComplete()


