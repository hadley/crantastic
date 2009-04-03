jQuery(function(){
        jQuery('.starselect').rating({
                callback: function(value, link){
                    jQuery(this.form).submit();
                }
            });
        jQuery('div.rating-cancel').remove();
    });
