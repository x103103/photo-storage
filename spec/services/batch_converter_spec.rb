# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchConverter do
  subject(:call) { described_class.new(root_dir, destination).call }

  let(:root_dir) { Rails.root.join('spec/fixtures/batch_converter') }
  let(:destination) { Rails.root.join('tmp/test_destination') }
  let(:image_converter) { instance_double(Image::Converter, call: true) }
  let(:video_converter) { instance_double(Video::Converter, call: true) }

  before do
    !Dir.exist?(destination) && Dir.mkdir(destination)
    allow(Image::Converter).to receive(:new).and_return(image_converter)
    allow(Video::Converter).to receive(:new).and_return(video_converter)
  end

  it 'calls the video converter' do
    call
    expected_params = [
      Rails.root.join('spec/fixtures/batch_converter/videos/MOV_0312_000.mp4').to_s,
      Rails.root.join('tmp/test_destination/MOV_0312_000.mp4').to_s,
    ]
    expect(Video::Converter).to have_received(:new).with(*expected_params)
  end

  it 'calls the image converter' do
    call
    expected_params = [
      Rails.root.join('spec/fixtures/batch_converter/images/DSC_0449.JPG').to_s,
      Rails.root.join('tmp/test_destination/DSC_0449.JPG').to_s,
    ]
    expect(Image::Converter).to have_received(:new).with(*expected_params)
  end

  context 'when dest exists' do
    before do
      File.new(Rails.root.join('tmp/test_destination/DSC_0449.JPG'), 'w')
    end

    after do
      File.delete(Rails.root.join('tmp/test_destination/DSC_0449.JPG'))
    end

    it 'adds _1 to the end of a dest' do
      call
      expected_params = [
        Rails.root.join('spec/fixtures/batch_converter/images/DSC_0449.JPG').to_s,
        Rails.root.join('tmp/test_destination/DSC_0449_1.JPG').to_s,
      ]
      expect(Image::Converter).to have_received(:new).with(*expected_params)
    end
  end
end
