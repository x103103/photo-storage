# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video::Converter do
  subject(:call) { described_class.new(source, destination).call }

  let(:source) { Rails.root.join('spec/fixtures/videos/MOV_0312_000.mp4') }
  let(:destination) { Rails.root.join('tmp/test_videos/MOV_0312_000.mp4') }
  let(:dir) { Rails.root.join('tmp/test_videos') }

  before { !Dir.exist?(dir) && Dir.mkdir(dir) }

  after { File.delete(destination) }

  it { is_expected.to be_truthy }

  it 'creates a file' do
    expect { call }.to change { File.exist?(destination) }.from(false).to(true)
  end
end
