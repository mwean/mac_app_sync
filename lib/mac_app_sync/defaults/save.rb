module MacAppSync
  module Defaults
    class Save
      attr_reader :domain_configs

      def self.run(config)
        new(config).run
      end

      def initialize(config)
        @domain_configs = parse_config(config)
      end

      def run
        return if domain_configs.empty?

        persistence.reset!
        save_domains
      end

      private

      def parse_config(config)
        config.fetch("defaults", []).map do |domain_config|
          if domain_config.is_a?(String)
            [domain_config, {}]
          else
            domain_config.to_a.first
          end
        end
      end

      def save_domains
        domain_configs.each do |domain, opts|
          save_domain(domain, opts)
        end
      end

      def save_domain(domain, opts)
        data = values_to_save(domain, opts)

        return if data.empty?

        persist(domain, data)
      end

      def values_to_save(domain, opts)
        all_values = Store.new(domain).values
        Filter.filter(all_values, opts)
      end

      def persist(domain, data)
        persistence.in_dir(domain) do
          data.each do |key, value|
            persistence.write(key, value)
          end
        end
      end

      def persistence
        @persistence ||= Persistence.new("defaults")
      end
    end
  end
end
