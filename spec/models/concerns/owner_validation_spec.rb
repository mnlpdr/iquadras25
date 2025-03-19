require 'rails_helper'

RSpec.describe Court, type: :model do
  describe 'owner validation' do
    let(:client) { create(:user, role: :client) }
    let(:court_owner) { create(:user, role: :court_owner) }
    
    it 'allows court_owner as owner' do
      court = build(:court, owner: court_owner)
      expect(court).to be_valid
    end

    it 'does not allow client as owner' do
      court = build(:court, owner: client)
      expect(court).not_to be_valid
      expect(court.errors[:owner]).to include("deve ser um dono de quadra")
    end
  end
end 