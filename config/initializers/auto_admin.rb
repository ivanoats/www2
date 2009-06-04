AutoAdmin.config do |admin|
  # This information is used by the theme to construct a useful
  # header; the first parameter is the full URL of the main site, the
  # second is the displayed name of the site, and the third (optional)
  # parameter is the title for the administration site.
  admin.set_site_info 'http://www.example.com/', 'example.com',
    'Administration area for example.com'

  # "Primary Objects" are those for which lists should be directly
  # accessible from the home page.
  admin.primary_objects = %w(account hosting user)

  admin.theme = :django # Optional; this is the default.

  # The configurable, optional access control system.
  #admin.admin_model = Account
  #admin.admin_model_id = :account_id

  # The optional export mechanism.
  #admin.save_as = %w(pdf csv)
end