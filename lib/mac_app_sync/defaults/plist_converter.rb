module MacAppSync
  module Defaults
    class PlistConverter
      TYPE_MAPPINGS = {
        CFPropertyList::CFDate => :date,
        CFPropertyList::CFBoolean => :boolean,
        CFPropertyList::CFInteger => :integer,
        CFPropertyList::CFReal => :float,
        CFPropertyList::CFString => :string,
        CFPropertyList::CFUid => :cfuid,
        CFPropertyList::CFData => :data,
        CFPropertyList::CFDictionary => :dict,
        CFPropertyList::CFArray => :array
      }

      class << self
        def to_ruby(plist_data)
          convert_plist_dict(plist_data)
        end

        def to_plist(value_data)
          build_plist_value(value_data.fetch("type"), value_data.fetch("value"))
        end

        private

        def convert_plist_value(container)
          case container
          when CFPropertyList::CFArray
            convert_plist_simple(convert_plist_array(container), :array)
          when CFPropertyList::CFDictionary
            convert_plist_simple(convert_plist_dict(container), :dict)
          when CFPropertyList::CFData
            convert_plist_simple(container.encoded_value, :data)
          else
            convert_plist_simple(container.value, TYPE_MAPPINGS.fetch(container.class))
          end
        end

        def build_plist_value(type, value)
          plist_class = TYPE_MAPPINGS.invert.fetch(type.to_sym)
          converted_value = convert_ruby_value(type, value)

          plist_class.new(converted_value)
        end

        def convert_ruby_value(type, value)
          case type
          when "array"
            value.map { |value_data| to_plist(value_data) }
          when "dict"
            value.map { |key, value_data| [key, to_plist(value_data)] }.to_h
          when "date"
            Time.parse(value)
          else
            value
          end
        end

        def convert_plist_array(container)
          container.value.map { |element| convert_plist_value(element) }
        end

        def convert_plist_dict(container)
          ruby_values = container.value.map { |key, element| [key, convert_plist_value(element)] }
          ruby_values.sort_by { |key, _| key }.to_h
        end

        def convert_plist_simple(value, type)
          {
            "value" => value,
            "type" => type
          }
        end
      end
    end
  end
end
