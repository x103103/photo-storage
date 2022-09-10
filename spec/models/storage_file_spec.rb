require 'rails_helper'

RSpec.describe StorageFile, type: :model do
  subject { build(:storage_file) }

  it { is_expected.to have_one_attached(:file) }
end
