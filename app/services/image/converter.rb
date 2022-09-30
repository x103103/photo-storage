# frozen_string_literal: true

module Image
  class Converter
    attr_reader :source, :destination

    def initialize(source, destination)
      @source = source
      @destination = destination
    end

    def call
      `vips jpegsave #{source} #{destination} --optimize-coding -Q 90`
      `touch -r #{source} #{destination}`
      true
    end
  end
end
