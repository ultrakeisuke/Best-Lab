require 'rails_helper'

RSpec.describe Admin, type: :model do
  let(:admin) { create(:admin) }

  it 'FactoryBotでadminデータが有効' do
    expect(admin).to be_valid
  end
end
