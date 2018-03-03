# spec/requests/entries_spec.rb
require 'rails_helper'

RSpec.describe 'Entries API', type: :request do
  # initialize test data
  let!(:prize) { create(:prize) }
  # Users
  let(:admin) { create(:user, role: 2) }
  let(:user) { create(:user, role: 1) }
  let(:guest) { create(:user, role: 0) }
  let(:user_not_owner) { create(:user, role: 1) }
  let(:params) { {} }
  # Entries
  let!(:entries) { FactoryBot.create_list(:entry, 8, user: user, prize: prize) }
  let!(:admin_entry) { create(:entry, user: admin) }
  let!(:user_entry) { create(:entry, user: user) }


  describe 'GET /entries' do
    before { get '/api/v1/entries', headers: auth_for(guest) }

    it 'returns all entries' do
      expect(response).to be_success
      expect(json_response[:data].size).to eq(10)
    end

    it 'returns status code 200' do
      get '/api/v1/entries', headers: auth_for(guest)
      expect(response).to have_http_status(200)
    end

    context 'authentication' do
      it 'returns status code 401' do
        get '/api/v1/entries', headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { '/api/v1/entries' }
      it_behaves_like 'GET authorization'
    end
  end

  describe 'GET /api/v1/entries/:id' do
    context 'when record exists' do
      before { get "/api/v1/entries/#{user_entry.id}", headers: auth_for(guest) }

      it 'returns the prize' do
        expect(json_response).not_to be_empty
        expect(json_response[:id]).to eq(user_entry.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when record does not exist' do
      it 'returns status code 404' do
        get "/api/v1/entries/99", headers: auth_for(guest)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        get "/api/v1/entries/#{user_entry.id}", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { "/api/v1/entries/#{user_entry.id}" }
      it_behaves_like 'GET authorization'
    end
  end

  describe 'PUT /api/v1/entries/:id' do
    let(:valid_payload) { { comment: 'Awesome!' } }

    context 'when record exists' do
      context 'when payload is valid' do
        it 'updates the record' do
          current_comment = user_entry.comment
          expect do
            put "/api/v1/entries/#{user_entry.id}", params: valid_payload, headers: auth_for(user)
          end.to change { user_entry.reload.comment }.from(current_comment).to('Awesome!')
        end

        it 'returns status code 200' do
          put "/api/v1/entries/#{admin_entry.id}", params: valid_payload, headers: auth_for(admin)
          expect(response).to have_http_status(200)
        end
      end

      context 'when payload is not valid' do
        let(:text_with_281_chars) { (0...281).map { (65 + rand(26)).chr }.join }
        before { put "/api/v1/entries/#{user_entry.id}", params: { comment: text_with_281_chars }, headers: auth_for(user) }

        it 'does not update' do
          current_comment = user_entry.comment
          expect(user_entry.reload.comment).to eq(current_comment)
        end

        it 'returns status code 406' do
          current_comment = user_entry.comment
          expect(response).to have_http_status(406)
        end
      end
    end

    context 'when record does not exist' do
      it 'returns status code 404' do
        get '/api/v1/entries/99', headers: auth_for(user)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        get '/api/v1/entries', headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :put }
      let(:params) { valid_payload }
      let(:url) { "/api/v1/entries/#{user_entry.id}" }
      it_behaves_like 'PUT authorization'
    end
  end

  describe 'DELETE /entries/:id' do
    context 'record exists' do
      it 'deletes the record' do
       expect do
          delete "/api/v1/entries/#{admin_entry.id}", headers: auth_for(admin)
        end.to change(Entry, :count).by(-1)
      end

      it 'returns status code 200' do
        delete "/api/v1/entries/#{admin_entry.id}", headers: auth_for(admin)
        expect(response).to have_http_status(200)
      end
    end

    context 'record does not exist' do
      it 'returns status code 404' do
        delete '/api/v1/entries/99', headers: auth_for(admin)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        delete "/api/v1/entries/#{user_entry.id}", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:url) { "/api/v1/entries/#{user_entry.id}" }
      let(:http_method) { :delete }
      it_behaves_like 'DELETE authorization'
    end
  end
end
