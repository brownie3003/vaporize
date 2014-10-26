(function() {
  $(function() {
    var allFlavoursPicked, autoPickFlavours, fullPage, resetFlavoursPicker, showFlavourPicker, showSubscription, user;
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
      var bottle, bottles, index, _i, _len, _results;
      bottles = $(".e-liquid-box-" + numberOfBottles);
      _results = [];
      for (index = _i = 0, _len = bottles.length; _i < _len; index = ++_i) {
        bottle = bottles[index];
        switch (index) {
          case 0:
            _results.push($(bottle).find("select").val("1"));
            break;
          case 1:
            _results.push($(bottle).find("select").val("2"));
            break;
          case 2:
            _results.push($(bottle).find("select").val("3"));
            break;
          case 3:
            _results.push($(bottle).find("select").val("1"));
            break;
          case 4:
            _results.push($(bottle).find("select").val("3"));
            break;
          default:
            _results.push(void 0);
        }
      }
      return _results;
    };
    resetFlavoursPicker = function() {
      $("#preSelectedBottles").addClass("hidden");
      $("#boxContent, [class*='e-liquid-box-']").addClass("hidden");
      $("#flavoursTip").removeClass("hidden");
      return $(".flavour-select").children().removeAttr("selected");
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
        $(".subscription-plan-select").val($(e.target).val());
        user.price = $(e.target).find(':selected').data('price');
        user.bottles = $(e.target).find(':selected').data('bottles');
        $("#flavours").removeClass("hidden");
        $("#flavoursTip").addClass("hidden");
        $(".subscription-offer").addClass("hidden");
        $("#showMeTheMoney").attr("disabled", true);
        if (user.ecigarette === "true") {
          $("#preSelectedBottles").removeClass("hidden");
          $("#bottleCount").text(user.bottles + "x10ml bottles");
          autoPickFlavours(user.bottles);
          $("#showMeTheMoney").attr("disabled", false);
        } else {
          $("#boxContent").removeClass("hidden");
          showFlavourPicker(user.bottles);
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
      return showFlavourPicker(user.bottles);
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
