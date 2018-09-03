require "pathname"
require "json"

module MacAppSync
  class Persistence
    SAVE_PATH = Pathname.new("~/.app_prefs").expand_path

    PATH_REPLACEMENTS = {
      "/" => "%-",
      ":" => "%.",
      "%" => "%%"
    }

    def self.write(name, content, path = SAVE_PATH)
      path.join(name).write(JSON.pretty_generate(content))
    end

    def initialize(namespace)
      @root_path = SAVE_PATH.join(namespace)
    end

    def reset!
      @root_path.rmtree if @root_path.exist?
      @root_path.mkpath
    end

    def in_dir(name)
      @save_path = @root_path.join(escape_path(name))
      @save_path.mkpath

      yield

      @save_path = @root_path
    end

    def write(name, content)
      self.class.write(escape_path(name), content, @save_path)
    end

    def each_file
      @root_path.each_child do |group|
        group.each_child do |file|
          content = JSON.parse(file.read)

          yield group.basename.to_s, file.basename.to_s, content
        end
      end
    end

    private

    def escape_path(str)
      pattern = "[#{PATH_REPLACEMENTS.keys.join}]"
      str.gsub(Regexp.new(pattern), PATH_REPLACEMENTS)
    end

    def unescape_path(str)
      str.gsub(/%./, PATH_REPLACEMENTS.invert)
    end
  end
end
