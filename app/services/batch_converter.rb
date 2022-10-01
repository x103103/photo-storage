# frozen_string_literal: true

class BatchConverter
  attr_reader :root_dir, :dest_dir

  def initialize(root_dir, dest_dir)
    @root_dir = root_dir
    @dest_dir = dest_dir
  end

  def call
    process_dir(root_dir)
  end

  private

  def process_dir(dir)
    Dir.each_child(dir) do |child|
      child_full_path = File.join(dir, child)
      if File.directory?(child_full_path)
        process_dir(child_full_path)
      else
        process_file(child_full_path)
      end
    end
  end

  def process_file(file_path)
    if image?(file_path)
      Image::Converter.new(file_path, dest(file_path)).call
    elsif video?(file_path)
      Video::Converter.new(file_path, dest(file_path)).call
    else
      Rails.logger.warn "unknown file: #{file_path}"
    end
  end

  def image?(file_path)
    File.extname(file_path).match?(/jpe?g/i)
  end

  def video?(file_path)
    File.extname(file_path).match?(/(mp4|mov|3gp)/i)
  end

  def dest(file_path)
    result = File.join(dest_dir, File.basename(file_path))
    if File.exist?(result)
      1.upto(100) do |i|
        basename = File.basename(file_path, '.*') + "_#{i}" + File.extname(file_path)
        result = File.join(dest_dir, basename)
        break unless File.exist?(result)
      end
    end
    result
  end
end
