require 'redmine'

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :redmine_cc_addresses do
  require_dependency 'cc_addresses_issue_show_hook'

  require_dependency 'issue'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Issue.included_modules.include? RedmineCcAddresses::IssuePatch
    Issue.send(:include, RedmineCcAddresses::IssuePatch)
  end

  require_dependency 'mailer'
  unless Mailer.included_modules.include? RedmineCcAddresses::MailerPatch
    Mailer.send(:include, RedmineCcAddresses::MailerPatch)
  end

  require_dependency 'mail_handler'
  unless MailHandler.included_modules.include? RedmineCcAddresses::MailHandlerPatch
    MailHandler.send(:include, RedmineCcAddresses::MailHandlerPatch)
  end

end

Redmine::Plugin.register :redmine_cc_addresses do
  name 'Issue CC Addresses'
  author 'Nick Peelman'
  description 'Allows CC Addresses to be attached to an issue'
  version '0.2.0'

  project_module :cc_addresses do |map|
    map.permission :view_cc_addresses, { }
    map.permission :add_cc_addresses, { :cc_addresses => :create }
    map.permission :delete_cc_addresses, { :cc_addresses => :destroy }
  end
end
