//Prototype script for Uni-Form by Patrick Daether - http://www.ihr-freelancer.de
zform = {
	settings: {	valid_class    : 'valid',
			   invalid_class  : 'invalid',
			    focused_class  : 'focused',
			    holder_selector   : '.zField, .zMultiField',
			    field_selector : '.zForm input, .zForm select, .zForm textarea'
	},
	// Select form fields and attach them higlighter functionality
	init: function(){
		$$(zform.settings.field_selector).invoke('observe','focus',zform.changeFocus);
		$$(zform.settings.holder_selector).invoke('observe','click',zform.selectField);
		$$('.zInlineField:last-child').each(function(e) {Element.setStyle(e,{'marginRight':'0px'})});
	},
	// Focus specific control holder
	changeFocus: function(evt){
		$$('.'+zform.settings.focused_class).invoke('removeClassName',zform.settings.focused_class);
		$(Event.element(evt)).up(zform.settings.holder_selector).addClassName(zform.settings.focused_class);
	},
	selectField: function(e) {
		input = e.element().down('input');
		if(input && input.type == "hidden") input = e.element().down('input',1);
		if(input) input.focus();
	}
}// Auto set on page load...
Event.observe(window, 'load', zform.init );