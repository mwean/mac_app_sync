module MacAppSync
  class Backup
    class << self
      def run(config)
        Defaults::Save.run(config)
        write_backup_stamp
      end

      private

      def write_backup_stamp
        platform_info = `ioreg -rd1 -c IOPlatformExpertDevice`
        machine_id = platform_info.match(/IOPlatformUUID"\s+=\s+"(\w{8}-\w{4}-\w{4}-\w{4}-\w*)/)[1]
        Persistence.write("last_backup", machine: machine_id, time: Time.now)
      end
    end
  end
end
