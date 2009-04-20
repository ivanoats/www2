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
	console.log('changeFocus')
			form.find('.' + settings.focused_class).removeClass(settings.focused_class);
			jQuery(element).parents(settings.holder_selector).addClass(settings.focused_class);
    };
		// 
		// var selectField = function(element) {
		// 	console.log('selectField')
		// 	
		// 	input = jQuery(this).find('input');
		// 	console.log(input)
		// 	if(input) changeFocus(input);
		// }

    // Select form fields and attach them higlighter functionality
    form.find(settings.field_selector).focus(function() {
		console.log('focused')
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





// init: function(){
// 	$$(zform.settings.field_selector).invoke('observe','focus',zform.changeFocus);
// 	$$(zform.settings.holder_selector).invoke('observe','click',zform.selectField);
// 	$$('.zInlineField:last-child').each(function(e) {Element.setStyle(e,{'marginRight':'0px'})});
// },
// // Focus specific control holder
// changeFocus: function(evt){
// 	$$('.'+zform.settings.focused_class).invoke('removeClassName',zform.settings.focused_class);
// 	$(Event.element(evt)).up(zform.settings.holder_selector).addClassName(zform.settings.focused_class);
// },
// selectField: function(e) {
// 	input = e.element().down('input');
// 	if(input && input.type == "hidden") input = e.element().down('input',1);
// 	if(input) input.focus();
// }