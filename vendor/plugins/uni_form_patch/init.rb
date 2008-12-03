require "uni_form_patch"

ActionView::Base.send :include, UniFormPatch
