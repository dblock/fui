module Fui
  # Represents an Xcode Project pbxproj file
  class Project
    attr_accessor :filename, :bridging_header, :path

    def self.project?(path)
      File.extname(path) == '.pbxproj'
    end

    def initialize(path)
      @path = path
      @filename = File.basename(path)
    end

    def bridging_headers(verbose)
      @bridging_headers ||= begin
        regex = /(SWIFT_OBJC_BRIDGING_HEADER) = \".+\"/
        bridging_headers = []
        File.new(path).grep regex do |result|
          tokens = result.split('"')
          next if tokens.length < 2

          path_tokens = tokens[1].split('/')
          bridging_header = path_tokens[path_tokens.length - 1]
          puts "Bridging Header Found: #{bridging_header} in #{project_path}." if verbose
          bridging_headers << bridging_header
        end
        bridging_headers.uniq
      end
    end
  end
end
