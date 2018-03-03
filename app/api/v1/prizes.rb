module V1
  class Prizes < Base

    resource :prizes do
      desc 'Get list of all prizes',
            success: Entities::Prize,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error]]
      params do
        optional :per_page, default: 10, type: Integer, desc: 'Per page to return'
        optional :page, default: 1, type: Integer, desc: 'Page number to return'
      end
      get do
        authorize Prize, :get?
        present_collection Prize.all, with: Entities::Prize
      end

      desc 'Create a prize',
            success: Entities::Prize,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [422, 'Validation error', Entities::Error]]
      params do
        requires :name, type: String, desc: 'Name of prize'
        optional :description, type: String, desc: 'Description of prize'
      end
      post do
        authorize Prize, :post?
        prize = Prize.create! declared_params_with_user
        present prize, with: Entities::Prize
      end

      route_param :id do
        desc 'Get prize by ID',
            success: Entities::Prize,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        get do
          prize = Prize.find(params[:id])
          authorize prize, :show?
          present prize, with: Entities::Prize
        end

        desc 'Update a prize',
            success: Entities::Prize,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [422, 'Validation error', Entities::Error],
                      [406, 'Invalid record', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        params do
          optional :name, type: String
          optional :description, type: String
          at_least_one_of :name, :description
        end
        put do
          prize = Prize.find params[:id]
          authorize prize, :put?
          prize.update!(declared_params)
          present prize, with: Entities::Prize
        end

        desc 'Delete a prize',
            success: Entities::Prize,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [406, 'Invalid record', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        delete do
          prize = Prize.find params[:id]
          authorize prize, :delete?
          prize.destroy!
        end

        resource :entries do
          desc 'Get entries of prize'
          get do
            authorize Entry, :get?
            prize = Prize.find params[:id]
            present_collection prize.entries, with: Entities::Entry
          end

          desc 'Create an entry to a prize',
            success: Entities::Prize,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [422, 'Validation error', Entities::Error],
                      [406, 'Invalid record', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
          params do
            requires :comment, type: String, desc: 'Comment on an entry'
          end
          post do
            authorize Entry, :post?
            prize = Prize.find params[:id]
            entry = prize.entries.create! declared_params_with_user
            present entry, with: Entities::EntryDetailed
          end
        end
      end
    end
  end
end
