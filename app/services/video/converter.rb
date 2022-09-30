# frozen_string_literal: true

module Video
  class Converter
    attr_reader :source, :destination

    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def call
      `HandBrakeCLI -i #{source} -o #{destination}`
      `touch -r #{source} #{destination}`
      true
    end
  end
end
