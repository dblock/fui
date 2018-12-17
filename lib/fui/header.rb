module Fui
  # Represents a Header (.h) file
  class Header
    attr_accessor :filename, :filename_without_extension, :path

    def self.header?(path)
      File.extname(path) == '.h'
    end

    def initialize(path)
      @path = path
      @filename = File.basename(path)
      @filename_without_extension = File.basename(path, File.extname(path))
    end
  end
end
