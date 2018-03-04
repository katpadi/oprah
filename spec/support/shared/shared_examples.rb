require 'spec_helper'

shared_examples_for 'Authorized' do
  it 'returns status code 200' do
    expect(response).to have_http_status(200)
  end
end

shared_examples_for 'Unauthorized' do
  it 'returns status code 403' do
    expect(response).to have_http_status(403)
  end
end

shared_examples_for 'POST authorization' do
  context 'guest role' do
    before { send(http_method, url, params: params, headers: auth_for(guest)) }
    it_behaves_like 'Unauthorized'
  end

  context 'user role' do
    before { send(http_method, url, params: params,  headers: auth_for(user)) }
    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end
  end

  context 'admin role' do
    before { send(http_method, url, params: params, headers: auth_for(admin)) }
    it 'returns status code 201' do
      expect(response).to have_http_status(201)
    end
  end
end

shared_examples_for 'GET authorization' do
  context 'guest role' do
    before { send(http_method, url, params: params, headers: auth_for(guest)) }
    it_behaves_like 'Authorized'
  end

  context 'user role' do
    before { send(http_method, url, params: params,  headers: auth_for(user)) }
    it_behaves_like 'Authorized'
  end

  context 'user role, not owner' do
    before { send(http_method, url, params: params, headers: auth_for(user_not_owner)) }
    it_behaves_like 'Authorized'
  end

  context 'admin role' do
    before { send(http_method, url, params: params, headers: auth_for(admin)) }
    it_behaves_like 'Authorized'
  end
end

shared_examples_for 'PUT authorization' do
  it_behaves_like 'common authorization'
end
shared_examples_for 'DELETE authorization' do
  it_behaves_like 'common authorization'
end

# Common for both PUT and DELETE
shared_examples_for 'common authorization' do
  context 'guest role' do
    before { send(http_method, url, params: params, headers: auth_for(guest)) }
    it_behaves_like 'Unauthorized'
  end

  context 'user role' do
    before { send(http_method, url, params: params,  headers: auth_for(user)) }
    it_behaves_like 'Authorized'
  end

  context 'user role, not owner' do
    before { send(http_method, url, params: params, headers: auth_for(user_not_owner)) }
    it_behaves_like 'Unauthorized'
  end

  context 'admin role' do
    before { send(http_method, url, params: params, headers: auth_for(admin)) }
    it_behaves_like 'Authorized'
  end
end
