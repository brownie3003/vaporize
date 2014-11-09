(function() {
  $(function() {
    var allFlavoursPicked, autoPickFlavours, fullPage, resetFlavoursPicker, setupFlavourPicker, showFlavourPicker, showSubscription, user;
    fullPage = $("#fullPage");
    if (fullPage.length) {
      fullPage.fullpage({
        verticalCentered: true,
        resize: false,
        css3: true,
        autoScrolling: false
      });
    }
    user = {};

    /* Functions */
    showSubscription = function() {
      $(".price").html("£" + user.price + "/month");
      if (user.ecigarette === "true") {
        $(".cigarette-offer").html("£25 for the e-cigarette kit");
        return $(".pricing-explanation").html("Your first payment will be £" + (user.price + 25) + " to pay for your e-cigarette kit. After this you will pay £" + user.price + " per month.");
      } else {
        $(".cigarette-offer").html("");
        return $(".pricing-explanation").html("You will simply pay £" + user.price + " per month for your e-liquid. It will be delivered through your letter box on the day you choose.");
      }
    };
    allFlavoursPicked = function(numberOfBottles) {
      var bottle, bottles, _i, _len;
      bottles = $(".e-liquid-box-" + numberOfBottles);
      for (_i = 0, _len = bottles.length; _i < _len; _i++) {
        bottle = bottles[_i];
        if ($(bottle).find("select").val() === "") {
          return false;
        }
      }
      $("#signUpTip").addClass("hidden");
      return true;
    };
    setupFlavourPicker = function(numberOfBottles) {
      var clone, eLiquidBottle, i, subscriptionId, _i, _results;
      subscriptionId = $(".e-liquid-bottle").find("select").attr("id");
      eLiquidBottle = $('.e-liquid-bottle');
      eLiquidBottle.find('select').attr('id', subscriptionId + "1");
      _results = [];
      for (i = _i = 2; 2 <= numberOfBottles ? _i <= numberOfBottles : _i >= numberOfBottles; i = 2 <= numberOfBottles ? ++_i : --_i) {
        clone = eLiquidBottle.clone();
        clone.find('select').attr('id', subscriptionId + i);
        if (numberOfBottles === 4) {
          $(".e-liquid-bottle").removeClass("col-xs-4").addClass("col-xs-3");
        }
        if (numberOfBottles === 5) {
          if (i === 4) {
            clone.removeClass('col-xs-4').addClass('col-xs-4 col-xs-offset-2');
          }
        }
        _results.push(clone.appendTo('#subscriptionBox'));
      }
      return _results;
    };
    showFlavourPicker = function() {
      return $('#boxContent').removeClass('hidden');
    };
    autoPickFlavours = function(numberOfBottles) {
      var bottles, i, _i, _results;
      bottles = $(".e-liquid-box-" + numberOfBottles);
      _results = [];
      for (i = _i = 1; 1 <= numberOfBottles ? _i <= numberOfBottles : _i >= numberOfBottles; i = 1 <= numberOfBottles ? ++_i : --_i) {
        if (i >= 4) {
          _results.push($('#subscription_choices_' + i).val(1));
        } else {
          _results.push($('#subscription_choices_' + i).val(i));
        }
      }
      return _results;
    };
    resetFlavoursPicker = function() {
      var eLiquidBottle;
      eLiquidBottle = $('.e-liquid-bottle').first();
      $("#preSelectedBottles").addClass("hidden");
      $("#boxContent").addClass("hidden");
      $("#flavoursTip").removeClass("hidden");
      $('.e-liquid-bottle').remove();
      eLiquidBottle.appendTo('#subscriptionBox');
      eLiquidBottle.find('select').attr('id', 'subscription_choices_');
      if (eLiquidBottle.hasClass('col-xs-3')) {
        return eLiquidBottle.removeClass('col-xs-3').addClass('col-xs-4');
      }
    };

    /* Hide stuff on load */
    $("#showMeTheMoney, #signUpButton").attr("disabled", true);

    /* Listeners */
    $('#subscriptionForm').on('change', function(e) {
      $("#showMeTheMoney").attr("disabled", true);
      if ($(e.target).attr('name') === 'subscription[initial_ecigarette]') {
        resetFlavoursPicker();
        user.ecigarette = $('input:radio[name = "subscription[initial_ecigarette]"]:checked').val();
        $("#quantityTip").addClass("hidden");
        $(".subscription-offer").addClass("hidden");
        $(".subscription-plan-select").children().removeAttr("selected");
        if (user.ecigarette === "true") {
          $("#subscriptionLevel").addClass("hidden");
          $("#dailyCigarettes").removeClass("hidden");
        } else {
          $("#dailyCigarettes").addClass("hidden");
          $("#subscriptionLevel").removeClass("hidden");
        }
        $.fn.fullpage.moveSectionDown();
      }
      if ($(e.target).attr('name') === "subscription[subscription_plan_id]") {
        resetFlavoursPicker();
        $('#showMeTheMoney').attr('disabled', false);
        $(".subscription-plan-select").val($(e.target).val());
        user.price = $(e.target).find(':selected').data('price');
        user.bottles = $(e.target).find(':selected').data('bottles');
        $("#flavours").removeClass("hidden");
        $("#flavoursTip").addClass("hidden");
        $(".subscription-offer").addClass("hidden");
        setupFlavourPicker(user.bottles);
        if (user.ecigarette === "true") {
          $("#preSelectedBottles").removeClass("hidden");
          $("#bottleCount").text(user.bottles + "x10ml bottles");
          autoPickFlavours(user.bottles);
          $("#showMeTheMoney").attr("disabled", false);
        } else {
          $("#boxContent").removeClass("hidden");
          showFlavourPicker();
        }
        $.fn.fullpage.moveSectionDown();
      }
      if ($(e.target).attr('name') === "subscription_choices[]") {
        if (allFlavoursPicked(user.bottles)) {
          return $("#showMeTheMoney").attr("disabled", false);
        }
      }
    });
    $("#letMePick").on('click', function() {
      $("#preSelectedBottles").addClass("hidden");
      $("#boxContent").removeClass("hidden");
      return showFlavourPicker();
    });
    $("#showMeTheMoney").on('click', function(e) {
      e.preventDefault();
      $(".subscription-offer").removeClass("hidden");
      $("#signUpButton").attr("disabled", false);
      $("#signUpTip").addClass("hidden");
      showSubscription();
      return $.fn.fullpage.moveSectionDown();
    });
    return $("#signUpButton, #enterAddress, #selectShippingDay, #enterCardDetails").on('click', function(e) {
      e.preventDefault();
      return $.fn.fullpage.moveSectionDown();
    });
  });

}).call(this);
