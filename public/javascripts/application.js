/* this was used for the tinymce editor, not currently used */
function toggleEditor(id) {
	if (!tinyMCE.getInstanceById(id))
		tinyMCE.execCommand('mceAddControl', false, id);
	else
		tinyMCE.execCommand('mceRemoveControl', false, id);
}

/* used to remove extra photo fields from article form */
function remove_field(element, item) {
  element.up(item).remove();
}