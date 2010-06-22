$(document).ready(function() {

    prettyPrint();

    $('a[rel*=facebox]').facebox();

    // Try to focus first text input
    $('input[@type=text]:first').focus();

    // hijacks the pagnation links in /packages
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

    $('a#more').livequery('click', function() {
                              $(this).remove();
                              $('#spinner').show();
                              jQuery.get(this.href, {}, function(next) {
                                             $('#timeline').append(next);
                                             $('#spinner').hide();
                                         });
                              return false;
                          });

    $('input#package-search').delayedObserver(function(value, object) {
            $("#packages_list").load('/packages/search',
                                     { 'search': escape($(this).val()) });
        $('#spinner').hide();
    }, 0.5);

    $('#add-tag').click(function() {
        $('#add-tag-form').toggle().find('#tag_name').focus();
        return false;
    });

    $("#login-or-signup").click(function() {
        jQuery.facebox(
            '<div class="float-l" style="width: 350px; height: 220px; border: 1px dotted #eee; padding: 9px 9px 9px 18px;">' +
                '<iframe src="https://crantastic.rpxnow.com/openid/embed?token_url=' +
                //'http://localhost:3000/session/rpx_token" ' +
                'http://crantastic.org/session/rpx_token" ' +
                'scrolling="no" frameBorder="no" style="width:350px;height:220px;"></iframe></div>' +
                '<div class="float-l" id="login-form" style="width: 320px; height: 220px; margin-left: 45px; padding: 9px 9px 9px 18px; border: 1px dotted #eee"></div>' +
                '<div style="position: absolute; top: 126px; left: 407px;"><h3 style="color: #aaa">OR</h3></div>',
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
