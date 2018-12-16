module Fui
  # A class to find various things in an Objective C project.
  class Finder
    attr_reader :path, :options

    def initialize(path, options = {})
      @path = File.expand_path(path)
      @options = options
      raise Errno::ENOENT, path unless Dir.exist?(@path)
    end

    def headers
      @headers ||= find(path) { |path| Header.header?(path) }.collect { |path| Header.new(path) }
    end

    def bridging_headers
      @bridging_headers ||= find(path) { |path| Project.project?(path) }.collect { |path| Project.new(path).bridging_headers(options[:verbose]) }
    end

    def ignores
      return unless options['ignore-path']

      @ignores ||= options['ignore-path'].map do |i|
        raise Errno::ENOENT, i unless Dir.exist?(i)

        Pathname(i)
      end
    end

    def references(&block)
      @references ||= begin
        references = {}
        headers.each do |header|
          references[header] = []
        end
        Find.find(path) do |path|
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
      @unused_references ||= references(&block).select { |k, v| v.count.zero? && !bridging_headers.include?(k.filename) }
    end

    private

    # Find all files for which the block yields.
    def find(path)
      results = []
      Find.find(path) do |fpath|
        if FileTest.directory?(fpath)
          next unless ignores

          ignores.each do |ignore|
            next unless fpath.include?(ignore.realpath.to_s)

            puts "Ignoring Directory: #{fpath}" if options[:verbose]
            Find.prune
          end
        end
        results << fpath if yield fpath
      end
      results
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

    def process_code(references, path)
      File.open(path) do |file|
        yield path if block_given?
        headers.each do |header|
          filename_without_extension = File.basename(path, File.extname(path))
          file_contents = File.read(file)
          global_import_exists = global_imported(file_contents, header)
          local_import_exists = local_imported(file_contents, header)
          references[header] << path if filename_without_extension != header.filename_without_extension && (local_import_exists || global_import_exists)
        end
      end
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
