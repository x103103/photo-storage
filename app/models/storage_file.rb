# frozen_string_literal: true

class StorageFile < ApplicationRecord
  has_one_attached :file
end
