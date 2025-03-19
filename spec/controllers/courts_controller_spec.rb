require 'rails_helper'

RSpec.describe CourtsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    # Configurar autenticação básica
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials('user','password')
  end

  let(:client) { create(:user, :client) }
  let(:court_owner) { create(:user, :court_owner) }
  let(:admin) { create(:user, :admin) }
  let(:sport) { create(:sport) }

  describe 'GET #index' do
    let!(:court) { create(:court, owner: court_owner) }
    let!(:court_with_sport) { create(:court, owner: court_owner, sports: [sport]) }

    context 'when user is client' do
      before do
        allow(request.env['warden']).to receive(:authenticate!).and_return(client)
        allow(controller).to receive(:current_user).and_return(client)
      end

      it 'shows all courts' do
        get :index
        expect(assigns(:courts)).to include(court, court_with_sport)
      end

      it 'filters by sport' do
        get :index, params: { sport_id: sport.id }
        expect(assigns(:courts)).to include(court_with_sport)
        expect(assigns(:courts)).not_to include(court)
      end
    end

    context 'when user is court owner' do
      before { sign_in court_owner }

      it 'shows only owned courts' do
        other_court = create(:court, owner: create(:user, role: :court_owner))
        get :index
        expect(assigns(:courts)).to include(court, court_with_sport)
        expect(assigns(:courts)).not_to include(other_court)
      end
    end

    context 'when user is admin' do
      before { sign_in admin }

      it 'shows all courts' do
        get :index
        expect(assigns(:courts)).to include(court, court_with_sport)
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { 
      attributes_for(:court).merge(sport_ids: [sport.id]) 
    }

    context 'when user is client' do
      before do 
        sign_in client
        allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      end

      it 'cannot create court' do
        post :create, params: { court: valid_attributes }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Acesso negado!")
      end
    end

    context 'when user is court owner' do
      before { sign_in court_owner }

      it 'creates a court and assigns self as owner' do
        expect {
          post :create, params: { court: valid_attributes }
        }.to change(Court, :count).by(1)
        
        expect(Court.last.owner).to eq(court_owner)
        expect(Court.last.sports).to include(sport)
      end
    end

    context 'when user is admin' do
      before { sign_in admin }

      it 'creates a court with specified owner' do
        valid_attributes_with_owner = valid_attributes.merge(owner_id: court_owner.id)
        
        expect {
          post :create, params: { court: valid_attributes_with_owner }
        }.to change(Court, :count).by(1)
        
        expect(Court.last.owner).to eq(court_owner)
      end
    end
  end

  describe 'PATCH #update' do
    let(:court) { create(:court, owner: court_owner) }
    let(:new_attributes) { { name: 'New Name', sport_ids: [sport.id] } }

    context 'when user is court owner' do
      before { sign_in court_owner }

      it 'updates own court' do
        patch :update, params: { id: court.id, court: new_attributes }
        court.reload
        expect(court.name).to eq('New Name')
        expect(court.sports).to include(sport)
      end

      it 'cannot update other owner\'s court' do
        other_court = create(:court, owner: create(:user, :court_owner))
        patch :update, params: { id: other_court.id, court: new_attributes }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Acesso negado!")
      end
    end
  end
end 