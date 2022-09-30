# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Image::Converter do
  subject(:call) { described_class.new(source, destination).call }

  let(:source) { Rails.root.join('spec/fixtures/images/DSC_0449.JPG') }
  let(:destination) { Rails.root.join('tmp/test_images/DSC_0449.JPG') }
  let(:dir) { Rails.root.join('tmp/test_images') }

  before { !Dir.exist?(dir) && Dir.mkdir(dir) }

  after { File.delete(destination) }

  it { is_expected.to be_truthy }

  it 'creates a file' do
    expect { call }.to change { File.exist?(destination) }.from(false).to(true)
  end
end
