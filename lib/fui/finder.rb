module Fui
  class Finder
    attr_reader :path

    def initialize(path)
      @path = File.expand_path(path)
      raise Errno::ENOENT.new(path) unless Dir.exists?(@path)
    end

    def headers
      @headers ||= Finder.find(path) { |path| Header.header?(path) }.collect { |path| Header.new(path) }
    end

    def references(&block)
      @references ||= begin
        references = {}
        headers.each do |header|
          references[header] = []
        end
        Find.find(path) do |path|
          next unless [".m", ".h", "*.pch"].include?(File.extname(path)) && File.ftype(path) == "file"
          File.open(path) do |file|
            filename = File.basename(path)
            yield path if block_given?
            headers.each do |header|
              filename_without_extension = File.basename(path, File.extname(path))
              references[header] << path if filename_without_extension != header.filename_without_extension && File.read(file).include?("#import \"#{header.filename}\"")
            end
          end
        end
        references
      end
    end

    def unused_references(&block)
      @unused_references ||= references(&block).select { |k, v| v.count == 0 }
    end

    private

    # Find all files for which the block yields.
    def self.find(path, &block)
      results = []
      Find.find(path) { |fpath|
        results << fpath if yield fpath
      }
      results
    end
  end
end
