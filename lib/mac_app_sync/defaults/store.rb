require "pathname"

module MacAppSync
  module Defaults
    class Store
      attr_reader :domain, :plist

      def initialize(domain)
        @domain = domain
        @plist = load_plist
      end

      def values
        PlistConverter.to_ruby(plist.value)
      end

      def to_binary
        plist.to_str(CFPropertyList::List::FORMAT_XML)
      end

      def set(key, value)
        new_value = PlistConverter.to_plist(value)
        current_value = plist.value.value[key]

        if Comparator.different?(current_value, new_value)
          plist.value.value[key] = new_value
        end
      end

      def plist_path
        @plist_path ||= prefs_file_path || container_file_path
      end

      private

      def load_plist
        CFPropertyList::List.new(file: plist_path).tap do |list|
          list.value = CFPropertyList::CFDictionary.new if plist_path.nil?
        end
      end

      def prefs_file_path
        prefs_file = Pathname.new("~/Library/Preferences/#{domain}.plist").expand_path
        prefs_file.to_s if prefs_file.exist?
      end

      def container_file_path
        container_path = "~/Library/Containers/#{domain}/Data/Library/Preferences/#{domain}.plist"
        container_file = Pathname.new(container_path).expand_path
        container_file.to_s if container_file.exist?
      end
    end
  end
end
