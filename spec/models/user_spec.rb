require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(client: 0, court_owner: 1, admin: 2) }
  end

  describe 'associations' do
    it { should have_many(:reservations).dependent(:destroy) }
    it { should have_many(:courts).with_foreign_key(:owner_id).dependent(:destroy) }
  end

  describe '#downcase_email' do
    it 'converts email to lowercase before saving' do
      user = User.new(
        name: 'Test User',
        email: 'TEST@EXAMPLE.COM',
        password: 'password123'
      )
      user.save
      expect(user.email).to eq('test@example.com')
    end
  end
end 