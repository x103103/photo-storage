# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'storage_files query' do
  subject(:result) { PhotoStorageSchema.execute(query).to_h }

  let(:query) do
    <<-GRAPHQL.strip
      {
        storageFiles {
          totalCount
          edges {
            node {
              id
              name
            }
          }
        }
      }
    GRAPHQL
  end
  let!(:storage_file) { create(:storage_file) }

  it 'returns correct data' do
    expected_data = {
      'data' => {
        'storageFiles' => include(
          'totalCount' => 1,
          'edges' => include(
            'node' => include(
              'id' => storage_file.id.to_s,
              'name' => storage_file.name,
            ),
          ),
        ),
      },
    }
    expect(result).to include(expected_data)
  end
end
