(function() {
  $(function() {
    var allFlavoursPicked, autoPickFlavours, fullPage, resetFlavoursPicker, showFlavourPicker, showSubscription, signUp, signupComplete, user;
    fullPage = $("#fullPage");
    if (fullPage.length) {
      fullPage.fullpage({
        verticalCentered: true,
        resize: false,
        css3: true,
        autoScrolling: false
      });
    }
    signUp = $("#signUp");
    if (signUp.length) {
      signUp.fullpage({
        resize: false,
        css3: true,
        autoScrolling: false
      });
    }
    user = {
      subscription: {
        price: void 0,
        bottles: void 0,
        flavours: {
          1: void 0
        }
      },
      cigarette: true
    };

    /* Functions */
    signupComplete = function() {
      return user.cigarette !== void 0 && user.subscription.price !== void 0 && allFlavoursPicked();
    };
    showSubscription = function() {
      $(".one-month").find(".price").html("£" + user.subscription.price + "/month");
      if (user.cigarette === true) {
        $(".one-month").find(".cigarette-offer").html("£25 for the e-cigarette kit");
        $(".one-month").find(".pricing-explanation").html("Your first payment will be £" + (user.subscription.price + 25) + " to pay for your e-cigarette kit. After this you will pay £" + user.subscription.price + " per month.");
      } else {
        $(".one-month").find(".pricing-explanation").html("You will simply pay £" + user.subscription.price + " per month for your e-liquid. It will be delivered through your letter box on the day you choose.");
      }
      return $.fn.fullpage.moveSectionDown();
    };
    allFlavoursPicked = function() {
      var flavoursCount, i, _i;
      flavoursCount = user.subscription.bottles;
      for (i = _i = 1; 1 <= flavoursCount ? _i <= flavoursCount : _i >= flavoursCount; i = 1 <= flavoursCount ? ++_i : --_i) {
        if (user.subscription.flavours[i] === void 0) {
          return false;
        }
      }
      return true;
    };
    showFlavourPicker = function(numberOfBottles) {
      var i, _i, _results;
      _results = [];
      for (i = _i = 3; _i <= 5; i = ++_i) {
        if (i === numberOfBottles) {
          _results.push($(".e-liquid-box-" + i).removeClass("hidden"));
        } else {
          _results.push($(".e-liquid-box-" + i).addClass("hidden"));
        }
      }
      return _results;
    };
    autoPickFlavours = function(numberOfBottles) {
      user.subscription.flavours[1] = "tabacco";
      user.subscription.flavours[2] = "menthol";
      user.subscription.flavours[3] = "blueberry";
      if (numberOfBottles === 5) {
        user.subscription.flavours[4] = "tabacco";
        user.subscription.flavours[5] = "apple";
      }
      if (numberOfBottles === 4) {
        return user.subscription.flavours[4] = "tabacco";
      }
    };
    resetFlavoursPicker = function() {
      $("#preSelectedBottles").addClass("hidden");
      return $("#boxContent, [class*='e-liquid-box-']").addClass("hidden");
    };

    /* Hide stuff on load */
    $("#showMeTheMoney, #pay").attr("disabled", true);

    /* Listeners */
    $('#subscription').on('change', function(e) {
      var cigaretteprice, pickNumber;
      $("#showMeTheMoney").attr("disabled", true);
      if ($(e.target).data('question') === 'e-cigarette') {
        cigaretteprice = $('input:radio[name = "e-cigarette"]:checked').val();
        $("#quantityTip").addClass("hidden");
        $(".subscription-offer").addClass("hidden");
        resetFlavoursPicker();
        if (cigaretteprice === "true") {
          user.cigarette = true;
          $("#subscriptionLevel").addClass("hidden");
          $("#dailyCigarettes").removeClass("hidden");
        } else {
          user.cigarette = false;
          $("#dailyCigarettes").addClass("hidden");
          $("#subscriptionLevel").removeClass("hidden");
        }
        $("#eLiquid").removeClass("hidden");
        $.fn.fullpage.moveSectionDown();
      }
      if ($(e.target).data('question') === 'subscription level') {
        user.subscription.price = parseInt($(e.target).val());
        $("#flavours").removeClass("hidden");
        $("#flavoursTip").addClass("hidden");
        $(".subscription-offer").addClass("hidden");
        resetFlavoursPicker();
        if (user.subscription.price === 12) {
          user.subscription.bottles = 3;
        } else if (user.subscription.price === 15) {
          user.subscription.bottles = 4;
        } else {
          user.subscription.bottles = 5;
        }
        user.subscription.flavours = {
          1: void 0
        };
        $("#showMeTheMoney").attr("disabled", true);
        if (user.cigarette === true) {
          $("#preSelectedBottles").removeClass("hidden");
          $("#bottleCount").text(user.subscription.bottles + "x10ml bottles");
          autoPickFlavours(user.subscription.bottles);
        } else {
          $("#boxContent").removeClass("hidden");
          showFlavourPicker(user.subscription.bottles);
        }
        $.fn.fullpage.moveSectionDown();
      }
      if ($(e.target).data('question') === "flavour") {
        pickNumber = $(e.target).attr("id").split("-")[1];
        user.subscription.flavours[pickNumber] = $(e.target).val();
      }
      if (signupComplete()) {
        $("#payTip").addClass("hidden");
        return $("#showMeTheMoney").attr("disabled", false);
      }
    });
    $("#letMePick").on('click', function() {
      user.subscription.flavours = {
        1: void 0
      };
      $("#showMeTheMoney, #pay").attr("disabled", true);
      $("#preSelectedBottles").addClass("hidden");
      $("#boxContent").removeClass("hidden");
      return showFlavourPicker(user.subscription.bottles);
    });
    $("#showMeTheMoney").on('click', function(e) {
      e.preventDefault();
      $.fn.fullpage.moveSectionDown();
      $(".subscription-offer").removeClass("hidden");
      $("#pay").attr("disabled", false);
      return showSubscription();
    });
    return $("#pay").on('click', function(e) {
      e.preventDefault();
      return $.ajax("/subscribe", {
        type: "GET",
        dataType: "json",
        data: user,
        complete: function() {
          return window.location.href = "/subscriptions/new";
        }
      });
    });
  });

}).call(this);
