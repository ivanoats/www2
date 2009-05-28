jQuery.fn.zform = function(settings) {
  settings = jQuery.extend({
    valid_class    : 'valid',
    invalid_class  : 'invalid',
    focused_class  : 'focused',
    holder_selector   : '.zField, .zMultiField',
    field_selector : '.zForm input, .zForm select, .zForm textarea'
  }, settings);
  
	jQuery('.zInlineField:last-child').each(function() {
		jQuery(this).css('margin-right', '0px');
	});

  return this.each(function() {
    var form = jQuery(this);
    
    // Focus specific control holder
    var changeFocus = function(element) {
			form.find('.' + settings.focused_class).removeClass(settings.focused_class);
			jQuery(element).parents(settings.holder_selector).addClass(settings.focused_class);
    };

    // Select form fields and attach them higlighter functionality
    form.find(settings.field_selector).focus(function() {
		
      changeFocus(jQuery(this));
    }).blur(function() {
      form.find('.' + settings.focused_class).removeClass(settings.focused_class);
    });

		form.find(settings.holder_selector).click(function() {
			input = jQuery(this).find(':input:visible:enabled:first')[0];
			if(input) changeFocus(input);
			
		})
  });
};

// Auto set on page load...
$(document).ready(function() {
  jQuery('form.zForm').zform();
});
