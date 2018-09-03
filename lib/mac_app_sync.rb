require "pathname"

require "cfpropertylist"

require "mac_app_sync/version"
require "mac_app_sync/persistence"
require "mac_app_sync/defaults"

require "mac_app_sync/backup"
require "mac_app_sync/restore"

module MacAppSync
  module_function

  def gem_root
    @gem_root ||= Pathname.new("..").expand_path(__dir__)
  end
end
