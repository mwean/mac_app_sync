module MacAppSync
  class Restore
    class << self
      def run(config)
        Defaults::Restore.run(config)
      end
    end
  end
end
