
function submit(form) {
    // given a valid form, submit the payment details to stripe
    $(form['submit-button']).attr("disabled", "disabled")
    Stripe.createToken({
        number: $('#stripe-card-number').val(),
        cvc: $('#stripe-cvc').val(),
        exp_month: $('#stripe-exp-month').val(),
        exp_year: $('#stripe-exp-year').val()
    }, function(status, response) {
        if (response.error) {
            // re-enable the submit button
            $(form['submit-button']).removeAttr("disabled")

            // show the error
            $(".payment-errors").html(response.error.message);
        } else {
            // token contains id, last4, and card type
            var token = response['id'];

            // insert the stripe token
            $('#stripe-token').val(token);

            // and submit
            form.submit();
        }
    });
}
