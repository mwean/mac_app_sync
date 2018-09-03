require "tempfile"

module MacAppSync
  module Defaults
    class Updater
      class << self
        def update(domain, store)
          with_tempfile(store.to_binary) do |file|
            if system("plutil -lint #{file.path}")
              system("defaults import #{store.plist_path} #{file.path}")
            else
              raise "Invalid plist for #{domain}"
            end
          end
        end

        private

        def with_tempfile(content)
          Tempfile.create("plist") do |file|
            file.write(content)
            File.chmod(0644, file)
            file.rewind

            yield file
          end
        end
      end
    end
  end
end
