module MacAppSync
  module Defaults
    class Comparator
      class << self
        def different?(a, b)
          different_type?(a, b) || different_value?(a, b)
        end

        private

        def different_type?(a, b)
          a.class != b.class
        end

        def different_value?(a, b)
          if a.is_a?(CFPropertyList::CFDictionary)
            different_size?(a.value, b.value) ||
            different_hash_values?(a.value, b.value)
          elsif a.is_a?(CFPropertyList::CFArray)
            different_size?(a.value, b.value) ||
            different_items?(a.value, b.value)
          else
            a.value != b.value
          end
        end

        def different_size?(a, b)
          a.size != b.size
        end

        def different_items?(a, b)
          a.any? do |a_item|
            b.all? { |b_item| different?(a_item, b_item) }
          end
        end

        def different_hash_values?(a, b)
          a.any? { |a_key, a_item| different?(a_item, b[a_key]) }
        end
      end
    end
  end
end
