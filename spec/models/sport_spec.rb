require 'rails_helper'

RSpec.describe Sport, type: :model do
  describe 'validations' do
    subject { create(:sport) }  # Cria um sport válido para testar uniqueness
    
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:court_sports) }
    it { should have_many(:courts).through(:court_sports) }
  end
end 