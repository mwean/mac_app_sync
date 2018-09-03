module MacAppSync
  module Defaults
    class Restore
      def self.run(_config)
        new.run
      end

      def run
        update_defaults
        write_updates
      end

      private

      def update_defaults
        persistence.each_file do |domain, key, content|
          stores[domain].set(key, content)
        end
      end

      def write_updates
        stores.each do |domain, store|
          Updater.update(domain, store)
        end
      end

      def persistence
        @persistence ||= Persistence.new("defaults")
      end

      def stores
        @stores ||= Hash.new { |hash, domain| hash[domain] = Store.new(domain) }
      end
    end
  end
end
