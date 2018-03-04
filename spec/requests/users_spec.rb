# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  # initialize test data
  let!(:users) { FactoryBot.create_list(:user, 7) }
  let!(:admin) { create(:user, role: :admin) }
  let!(:user) { create(:user, role: 1) }
  let!(:user_not_owner) { create(:user, role: :user) }
  let!(:guest) { create(:user, role: :guest) }

  let(:params) { {} }

  describe 'GET /users' do
    it 'returns all user' do
      get '/api/v1/users', headers: auth_for(user)
      expect(response).to be_success
      expect(json_response[:data].size).to eq(10)
    end

    it 'returns status code 200' do
      get '/api/v1/users', headers: auth_for(user)
      expect(response).to have_http_status(200)
    end

    context 'authentication' do
      it 'returns status code 401' do
        get '/api/v1/users', headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { '/api/v1/users' }
      it_behaves_like 'GET authorization'
    end
  end

  # describe 'GET /api/v1/users/:id' do
  describe 'GET /users' do
    context 'when the record exists' do
      before { get "/api/v1/users/#{user.id}", headers: auth_for(user) }

      it 'returns the user' do
        expect(json_response).not_to be_empty
        expect(json_response[:id]).to eq(user.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      before { get "/api/v1/users/999", headers: auth_for(admin) }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(json_response[:code]).to eq('not_found_error')
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        get "/api/v1/users/#{user.id}", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :get }
      let(:url) { "/api/v1/users/#{user.id}" }
      it_behaves_like 'GET authorization'
    end
  end

  # Describe PUT /users/:id
  describe 'PUT /api/v1/users/:id' do
    let(:valid_payload) { { name: 'New Name' } }

    context 'when the record exists' do
      context 'when payload is valid' do
        it 'updates the record' do
          current_name = admin.name
          expect do
            put "/api/v1/users/#{admin.id}", params: valid_payload, headers: auth_for(admin)
          end.to change { admin.reload.name }.from(current_name).to('New Name')
        end

        it 'returns status code 200' do
          put "/api/v1/users/#{admin.id}", params: valid_payload, headers: auth_for(admin)
          expect(response).to have_http_status(200)
        end
      end

      context 'when payload is not valid' do
        before { put "/api/v1/users/#{admin.id}", params: { name: '' }, headers: auth_for(admin) }

        it 'does not update' do
          current_name = admin.name
          expect(admin.reload.name).to eq(current_name)
        end

        it 'returns status code 406' do
          current_name = admin.name
          expect(response).to have_http_status(406)
        end
      end
    end

    context 'when record does not exist' do
      it 'returns status code 404' do
        get '/api/v1/users/99', headers: auth_for(admin)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        get '/api/v1/users', headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :put }
      let(:params) { valid_payload }
      let(:url) { "/api/v1/users/#{user.id}" }
      it_behaves_like 'PUT authorization'
    end
  end

  describe 'DELETE /users/:id' do
    context 'when record exists' do
      it 'deletes the record' do
        expect do
          delete "/api/v1/users/#{user.id}", headers: auth_for(admin)
        end.to change(User, :count).by(-1)
      end

      it 'returns status code 200' do
        delete "/api/v1/users/#{user.id}", headers: auth_for(admin)
        expect(response).to have_http_status(200)
      end
    end

    context 'record does not exist' do
      it 'returns status code 404' do
        delete '/api/v1/users/99', headers: auth_for(admin)
        expect(response).to have_http_status(404)
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        delete "/api/v1/users/#{user.id}", headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:url) { "/api/v1/users/#{user.id}" }
      let(:http_method) { :delete }
      it_behaves_like 'DELETE authorization'
    end
  end

  describe 'POST /users' do
    let(:valid_payload) {{ name: 'Kobe Bryant', password: '12345678', email: 'kobe@katpadi.ph' }}
    context 'when the payload is valid' do
      it 'returns status code 201' do
        post '/api/v1/users', params: valid_payload, headers: auth_for(admin)
        expect(response).to have_http_status(201)
      end

      it 'creates a user' do
        expect do
          post "/api/v1/users", params: valid_payload, headers: auth_for(admin)
        end.to change(User, :count).by(1)
        expect(User.last.name).to eq(json_response[:name])
        expect(User.last.email).to eq(json_response[:email])
        expect(user.valid_password?('12345678')).to be_truthy
      end
    end

    context 'when the payload is invalid' do
      # let(:valid_password) { '12345678' }
      # let(:valid_email) { 'kat.padilla@katpadi.ph' }
      # let(:valid_name) { 'KATRINA' }

      context 'email is not present' do
        it 'returns status code 422' do
          payload = valid_payload.merge(email: '')
          post "/api/v1/users", params: payload, headers: auth_for(admin)
          expect(response).to have_http_status(422)
        end
      end

      context 'email is invalid format' do
        it 'returns status code 422' do
          payload = valid_payload.merge(email: 'xxxx.com')
          post "/api/v1/users", params: payload, headers: auth_for(admin)
          expect(response).to have_http_status(422)
        end
      end

      context 'email is already taken' do
        before { create(:user, role: :admin, email: 'kat@awesomeness.com') }
        it 'returns status code 406' do
          payload = valid_payload.merge(email: 'kat@awesomeness.com')
          post "/api/v1/users", params: payload, headers: auth_for(admin)
          expect(response).to have_http_status(406)
        end
      end

      context 'password is not present' do
        it 'returns status code 422' do
          payload = { email: 'coolio@katpadi.ph', name: 'LL Cool J' }
          post "/api/v1/users", params: payload, headers: auth_for(admin)
          expect(response).to have_http_status(422)
        end
      end

      context 'password length is invalid' do
        it 'returns status code 406' do
          payload = valid_payload.merge(password: '1234567')
          post "/api/v1/users", params: payload, headers: auth_for(admin)
          expect(response).to have_http_status(406)
        end
      end

      context 'name is not present' do
        it 'returns status code 422' do
          payload = { email: 'coolio@katpadi.ph', passowrd: 'LLCoolJ' }
          post "/api/v1/users", params: payload, headers: auth_for(admin)
          expect(response).to have_http_status(422)
        end
      end
    end

    context 'authentication' do
      it 'returns status code 401' do
        post "/api/v1/users/", params: valid_payload, headers: bad_auth
        expect(response).to have_http_status(401)
      end
    end

    context 'authorization' do
      let(:http_method) { :post }
      let(:params) { valid_payload }
      let(:url) { "/api/v1/users" }
      it_behaves_like 'POST authorization'
    end
  end
end
