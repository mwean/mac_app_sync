require "yaml"

module MacAppSync
  module Defaults
    class Filter
      class << self
        def filter(data, opts)
          user_filter(global_filter(data), opts)
        end

        private

        def global_filter(data)
          data.reject do |key, _value|
            global_exclude_keys.include?(key) ||
            global_exclude_patterns.any? { |pattern| key =~ pattern }
          end
        end

        def user_filter(data, opts)
          return data if opts.empty?

          should_exclude = build_filter(opts)
          data.reject { |key, _| should_exclude.call(key) }
        end

        def build_filter(opts)
          if opts["only"]
            include_filter(opts)
          else
            exclude_filter(opts)
          end
        end

        def include_filter(opts)
          only = wrap(opts["only"]).to_set
          ->(key) { !only.include?(key) }
        end

        def exclude_filter(opts)
          excludes = wrap(opts["exclude"]).to_set
          exclude_patterns = wrap(opts["exclude_patterns"]).map { |pattern| Regexp.new(pattern) }

          lambda do |key|
            excludes.include?(key) || exclude_patterns.any? { |pattern| key =~ pattern }
          end
        end

        def wrap(object)
          if object.nil?
            []
          elsif object.respond_to?(:to_ary)
            object.to_ary || [object]
          else
            [object]
          end
        end

        def global_exclude_keys
          @global_exclude_keys ||= global_exclusions.fetch("keys").to_set
        end

        def global_exclude_patterns
          @global_exclude_patterns ||= global_exclusions.fetch("patterns").map do |pattern|
            Regexp.new(pattern)
          end
        end

        def global_exclusions
          @global_exclusions ||= YAML.load_file(MacAppSync.gem_root.join("config", "global_defaults_exclusions.yml"))
        end
      end
    end
  end
end
