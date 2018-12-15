module Fui
  class Finder
    attr_reader :path, :options

    def initialize(path, options = {})
      @path = File.expand_path(path)
      @options = options
      raise Errno::ENOENT, path unless Dir.exist?(@path)
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
          next unless File.ftype(path) == 'file'

          if ['.m', '.mm', '.h', '.pch'].include?(File.extname(path))
            process_code references, path, &block
          elsif ['.storyboard', '.xib'].include?(File.extname(path))
            process_xml references, path, &block
          end
        end
        references
      end
    end

    def unused_references(&block)
      @unused_references ||= references(&block).select { |_k, v| v.count == 0 }
    end

    private

    # Find all files for which the block yields.
    def self.find(path)
      results = []
      Find.find(path) do |fpath|
        results << fpath if yield fpath
      end
      results
    end

    def process_code(references, path)
      File.open(path) do |file|
        yield path if block_given?
        filename = File.basename(path)
        headers.each do |header|
          filename_without_extension = File.basename(path, File.extname(path))
          file_contents = File.read(file)
          global_import_exists = global_imported(file_contents, header)
          local_import_exists = local_imported(file_contents, header)
          references[header] << path if filename_without_extension != header.filename_without_extension && (local_import_exists || global_import_exists)
        end
      end
    end

    def local_imported(file_contents, header)
      return false if options['ignore-local-imports']

      file_contents.include?("#import \"#{header.filename}\"")
    end

    def global_imported(file_contents, header)
      return false if options['ignore-global-imports']

      escaped_header = Regexp.quote(header.filename)
      regex = '(#import\s{1}<.+\/' + escaped_header + '>)'
      file_contents.match(regex)
    end

    def process_xml(references, path)
      File.open(path) do |file|
        yield path if block_given?
        headers.each do |header|
          filename_without_extension = File.basename(path, File.extname(path))
          check_xibs = !options['ignore-xib-files']
          references[header] << path if (check_xibs || filename_without_extension != header.filename_without_extension) && File.read(file).include?("customClass=\"#{header.filename_without_extension}\"")
        end
      end
    end
  end
end
