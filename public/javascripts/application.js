jQuery(function(){
        jQuery('.starselect').rating({
                callback: function(value, link){
                    jQuery(this.form).submit();
                }
            });
        jQuery('div.rating-cancel').remove();
    });

$(document).ready(function() {
      $('div.pagination a').livequery('click', function() {
          $('#packages_list').load(this.href);
          return false;
      });

      $('input#search').delayedObserver(function(value, object) {
              $("#packages_list").load('/packages',
                                       { search: escape($("input#search").val())
              });
              $('#spinner').hide();
          }, 0.5);
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
