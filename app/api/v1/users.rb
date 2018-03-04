module V1
  class Users < Base
    include ::Helpers::AuthHelpers

    resource :users do
      desc 'Get list of all users',
            success: Entities::User,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error]]
      params do
        optional :per_page, default: 10, type: Integer, desc: 'Per page to return'
        optional :page, default: 1, type: Integer, desc: 'Page number to return'
      end
      get do
        authorize User, :get?
        present_collection User.all, with: Entities::User
      end

      desc 'Create a user',
            success: Entities::User,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [422, 'Validation error', Entities::Error]]
      params do
        requires :email, type: String, desc: 'Email of user', regexp: Devise::email_regexp
        requires :name, type: String, desc: 'Name of user'
        requires :password, type: String, desc: 'Password of user'
      end
      post do
        authorize User, :post?
        user = User.create! declared_params
        present user, with: Entities::User
      end

      route_param :id do
        desc 'Get user by ID',
            success: Entities::User,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        get do
          user = User.find(params[:id])
          authorize user, :show?
          present user, with: Entities::User
        end

        desc 'Update a user',
            success: Entities::User,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [422, 'Validation error', Entities::Error],
                      [406, 'Invalid record', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        params do
          optional :name, type: String
        end
        put do
          user = User.find params[:id]
          authorize user, :put?
          user.update!(declared_params)
          present user, with: Entities::User
        end

        desc 'Delete a user',
            success: Entities::User,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [406, 'Invalid record', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        delete do
          user = User.find params[:id]
          authorize user, :delete?
          user.destroy!
        end
      end
    end
  end
end
