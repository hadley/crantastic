$(document).ready(function() {
        // Try to focus first text input
        $('input[@type=text]:first').focus();

      $('div.pagination a').livequery('click', function() {
          $('#packages_list').load(this.href);
          return false;
      });

      $('input#package-search').delayedObserver(function(value, object) {
              $("#packages_list").load('/packages',
                                       { search: escape($(this).val())
              });
              $('#spinner').hide();
          }, 0.5);

      $('#add-tag').click(function() {
              $('#add-tag-form').toggle().find('#tag_name').focus();
              return false;
          });
    });

jQuery(function(){
        jQuery('.starselect').rating({
                callback: function(value, link){
                    jQuery(this.form).submit();
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
