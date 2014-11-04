(function() {
  jQuery(function($) {
    var stripeResponseHandler;
    $("#subscriptionForm").submit(function(event) {
      var $form;
      $form = $(this);
      $form.find("input[type='submit']").prop("disabled", true);
      Stripe.setPublishableKey('pk_test_pLDgmguQNCcVdl40qgCxWfke');
      Stripe.card.createToken($form, stripeResponseHandler);
      return false;
    });
    return stripeResponseHandler = function(status, response) {
      var $form, token;
      $form = $("#subscriptionForm");
      if (response.error) {
        $form.find(".payment-errors").text(response.error.message);
        return $form.find("input[type='submit']").prop("disabled", false);
      } else {
        token = response.id;
        $form.append($("<input type=\"hidden\" name=\"stripeToken\" />").val(token));
        return $form.get(0).submit();
      }
    };
  });

}).call(this);
