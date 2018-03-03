# spec/requests/prizes_spec.rb
require 'rails_helper'

RSpec.describe 'Prizes API', type: :request do
  # initialize test data
  # Users
  let(:admin) { create(:user, role: 2) }
  let(:user) { create(:user, role: 1) }
  let(:user_not_owner) { create(:user, role: 1) }
  let(:guest) { create(:user, role: 0) }

  # Prizes
  let!(:prizes) { FactoryBot.create_list(:prize, 8) }
  let!(:admin_prize) { create(:prize, user: admin) }
  let!(:user_prize) { create(:prize, user: user) }

  # Entries
  let!(:entries) { FactoryBot.create_list(:entry, 10, user: user, prize: user_prize) }
  let!(:entry) { entries.first }

  let(:params) { {} }

  describe 'GET /prizes' do
    it 'returns all prizes' do
      get '/api/v1/prizes', headers: auth_for(guest)
      expect(response).to be_success
      expect(json_response[:data].size).to eq(10)
    end

    it 'returns status code 200' do
      get '/api/v1/prizes', headers: auth_for(user)
      expect(response).to have_http_status(200)
    end

    context 'authentication' do
      it 'returns status code 401' do
        get '/api/v1/prizes', headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { '/api/v1/prizes' }
      it_behaves_like 'GET authorization'
    end
  end

  describe 'GET /api/v1/prizes/:id' do
    context 'when the record exists' do
      before { get "/api/v1/prizes/#{admin_prize.id}", headers: auth_for(user) }

      it 'returns the prize' do
        expect(json_response).not_to be_empty
        expect(json_response[:id]).to eq(admin_prize.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { get "/api/v1/prizes/999", headers: auth_for(admin) }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json_response[:code]).to eq('not_found_error')
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        get "/api/v1/prizes/#{user_prize.id}", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { "/api/v1/prizes/#{user_prize.id}" }
      it_behaves_like 'GET authorization'
    end
  end

  # Test suite for PUT /prizes/:id
  describe 'PUT /api/v1/prizes/:id' do
    let(:valid_payload) { { name: 'Updated name!' } }

    context 'when the record exists' do
      context 'when payload is valid' do
        it 'updates the record' do
          current_name = admin_prize.name
          expect do
            put "/api/v1/prizes/#{admin_prize.id}", params: valid_payload, headers: auth_for(admin)
          end.to change { admin_prize.reload.name }.from(current_name).to('Updated name!')
        end

        it 'returns status code 200' do
          put "/api/v1/prizes/#{admin_prize.id}", params: valid_payload, headers: auth_for(admin)
          expect(response).to have_http_status(200)
        end
      end

      context 'when payload is not valid' do
        before { put "/api/v1/prizes/#{user_prize.id}", params: { name: '' }, headers: auth_for(user) }

        it 'does not update' do
          current_name = user_prize.name
          expect(user_prize.reload.name).to eq(current_name)
        end

        it 'returns status code 406' do
          current_name = user_prize.name
          expect(response).to have_http_status(406)
        end
      end
    end

    context 'when record does not exist' do
      it 'returns status code 404' do
        get '/api/v1/prizes/99', headers: auth_for(user)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        get '/api/v1/prizes', headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :put }
      let(:params) { valid_payload }
      let(:url) { "/api/v1/prizes/#{user_prize.id}" }
      it_behaves_like 'PUT authorization'
    end
  end

  describe 'DELETE /prizes/:id' do
    context 'when record exists' do
      it 'deletes the record' do
        expect do
          delete "/api/v1/prizes/#{user_prize.id}", headers: auth_for(admin)
        end.to change(Prize, :count).by(-1)
      end

      it 'returns status code 200' do
        delete "/api/v1/prizes/#{user_prize.id}", headers: auth_for(admin)
        expect(response).to have_http_status(200)
      end
    end

    context 'record does not exist' do
      it 'returns status code 404' do
        delete '/api/v1/prizes/99', headers: auth_for(admin)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        delete "/api/v1/prizes/#{user_prize.id}", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:url) { "/api/v1/prizes/#{user_prize.id}" }
      let(:http_method) { :delete }
      it_behaves_like 'DELETE authorization'
    end
  end

  describe 'POST /prizes/:id/entries' do
    let(:valid_payload) {{ comment: 'yeaaaah!' }}
    context 'when prize record exists' do
      context 'when the payload is valid' do
        it 'returns status code 201' do
          post "/api/v1/prizes/#{admin_prize.id}/entries", params: valid_payload, headers: auth_for(admin)
          expect(response).to have_http_status(201)
        end

        it 'creates an entry to prize' do
          expect do
            post "/api/v1/prizes/#{admin_prize.id}/entries", params: valid_payload, headers: auth_for(admin)
          end.to change(Entry, :count).by(1)
          expect(Entry.last.comment).to eq(json_response[:comment])
          expect(json_response[:comment]).to eq('yeaaaah!')
        end
      end

      context 'when the payload is invalid' do
        it 'returns status code 422' do
          post "/api/v1/prizes/#{admin_prize.id}/entries", params: {}, headers: auth_for(user)
          expect(response).to have_http_status(422)
        end

        it 'does not create a prize' do
          expect do
            post "/api/v1/prizes/#{admin_prize.id}/entries", params: valid_payload, headers: auth_for(guest)
          end.to change(Entry, :count).by(0)
        end
      end
    end

    context 'when prize record does not exist' do
      it 'returns status code 404' do
        get '/api/v1/prizes/999999/entries', headers: auth_for(user)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        post "/api/v1/prizes/#{admin_prize.id}/entries", params: valid_payload, headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :post }
      let(:params) { valid_payload }
      let(:url) { "/api/v1/prizes/#{user_prize.id}/entries" }
      it_behaves_like 'POST authorization'
    end
  end

  describe 'GET /prizes/:id/entries' do
    it 'returns all entries of prize' do
      get "/api/v1/prizes/#{user_prize.id}/entries", headers: auth_for(guest)
      expect(json_response[:data].size).to eq(10)
    end

    it 'returns status code 200' do
      get "/api/v1/prizes/#{user_prize.id}/entries", headers: auth_for(user)
      expect(response).to have_http_status(200)
    end

    context 'authentication' do
      it 'returns status code 401' do
        get "/api/v1/prizes/#{user_prize.id}/entries", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { "/api/v1/prizes/#{user_prize.id}/entries" }
      it_behaves_like 'GET authorization'
    end
  end
end
