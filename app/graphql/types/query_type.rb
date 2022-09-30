# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :storage_files, Types::StorageFileConnectionType, null: false, connection: true do
      argument :order_field, String, required: false, default_value: 'created_at'
      argument :order_direction, String, required: false, default_value: 'desc'
    end

    def storage_files(order_field:, order_direction:)
      arel = StorageFile.arel_table
      order = arel[order_field].public_send(order_direction)
      StorageFile.order(order)
    end
  end
end
