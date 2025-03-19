require 'rails_helper'

RSpec.describe Court, type: :model do
  describe 'associations' do
    it { should belong_to(:owner).class_name('User') }
    it { should have_many(:reservations).dependent(:destroy) }
    it { should have_many(:court_sports).dependent(:destroy) }
    it { should have_many(:sports).through(:court_sports) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:capacity) }
    it { should validate_presence_of(:price_per_hour) }
    it { should validate_presence_of(:owner) }
    
    it { should validate_numericality_of(:capacity).is_greater_than(0) }
    it { should validate_numericality_of(:price_per_hour).is_greater_than(0) }
  end

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

  describe 'scopes' do
    let(:court_owner) { create(:user, role: :court_owner) }
    
    describe '.by_owner' do
      it 'returns courts for specific owner' do
        court = create(:court, owner: court_owner)
        other_court = create(:court, owner: create(:user, role: :court_owner))
        
        expect(Court.by_owner(court_owner.id)).to include(court)
        expect(Court.by_owner(court_owner.id)).not_to include(other_court)
      end
    end

    describe '.by_sport' do
      let(:sport) { create(:sport) }
      
      it 'returns courts with specified sport' do
        court_with_sport = create(:court, owner: court_owner, sports: [sport])
        court_without_sport = create(:court, owner: court_owner)
        
        expect(Court.by_sport(sport.id)).to include(court_with_sport)
        expect(Court.by_sport(sport.id)).not_to include(court_without_sport)
      end

      it 'returns all courts when no sport specified' do
        court = create(:court, owner: court_owner)
        expect(Court.by_sport(nil)).to eq(Court.all)
      end
    end
  end
end 