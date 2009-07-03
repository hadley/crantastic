$(document).ready(function() {

    $('a[rel*=facebox]').facebox();

    // Try to focus first text input
    $('input[@type=text]:first').focus();

    $('div.pagination a').livequery('click', function() {
        var href = this.href;
        // Appends the search term to the URL, to facilitate
        // browser history and bookmarking
        if ($("#package-search")[0].value != "" && !href.match(/&search=/)) {
            href += "&search=" + $("#package-search")[0].value;
        }
        location.href = href;
        return false;
    });

    $('input#package-search').delayedObserver(function(value, object) {
        $("#packages_list").load('/packages',
                                 { search: escape($(this).val()) });
        $('#spinner').hide();
    }, 0.5);

    $('#add-tag').click(function() {
        $('#add-tag-form').toggle().find('#tag_name').focus();
        return false;
    });

    $("#login-or-signup").click(function() {
        jQuery.facebox(
            '<div class="float-l" style="width: 390px">' +
                '<iframe src="https://crantastic.rpxnow.com/openid/embed?token_url=' +
                //'http://localhost:3000/session/rpx_token" ' +
                'http://crantastic.org/session/rpx_token" ' +
                'scrolling="no" frameBorder="no" style="width:370px;height:240px;"></iframe></div>' +
                '<div class="float-l" id="login-form"></div>',
            'wide'
        );
        $("#login-form").load("/login?show_rpx=false&layout=false");
        return false;
    });

});

jQuery(function(){
    jQuery('.starselect').rating({
        callback: function(value, link){
            // Submit the vote
            $.post(this.form.action, $(this.form).serialize());

            // Display thank you message
            $(this.form).parent().parent().find(
                "span.your-rating:first").html("Thank you for your vote!");

            var aspect = $(this.form).find("input[name=aspect]:first")[0].value;

            // Update rating stats
            $.getJSON(this.form.action + "?aspect=" + aspect, function(data) {
                      $("span#" + aspect + "-rating").html(
                          data.average_rating + "/5 (" + data.votes +
                              (data.votes == 1 ? " vote" :" votes") + ")"
                      )
            });
            return false;
        }
    });
    jQuery('div.rating-cancel').remove();
});

$(document).ajaxSend(function(event, request, settings) {
    if (settings.type == 'GET' || settings.type == 'get' || typeof(AUTH_TOKEN) == "undefined") return;
    // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});

jQuery.ajaxSetup({
    'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
