# frozen_string_literal: true

module Types
  class StorageFileConnectionType < Types::BaseConnection
    edge_type(Types::StorageFileEdgeType)

    field :total_count, Integer, null: false

    def total_count
      # - `object` is the Connection
      # - `object.nodes` is the collection of Posts
      object.items.size
    end
  end
end
