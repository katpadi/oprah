module V1
  class Entries < Base

    resource :entries do
      desc 'Get list of all entries',
            is_array: true,
            success: Entities::Entry,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error]]
      params do
        optional :per_page, default: 10, type: Integer, desc: 'Per page to return'
        optional :page, default: 1, type: Integer, desc: 'Page number to return'
      end
      get do
        authorize Entry, :get?
        present_collection Entry.all, with: Entities::Entry
      end

      route_param :id do
        desc 'Get entry by ID',
              success: Entities::EntryDetailed,
              failure: [[401, 'Unauthenticated access', Entities::Error],
                        [403, 'Forbidden access', Entities::Error],
                        [404, 'Resource not found', Entities::Error]]
        get do
          authorize Entry, :show?
          entry = Entry.find(params[:id])
          present entry, with: Entities::EntryDetailed
        end

        desc 'Update an entry',
              success: Entities::EntryDetailed,
              failure: [[401, 'Unauthenticated access', Entities::Error],
                        [403, 'Forbidden access', Entities::Error],
                        [422, 'Validation error', Entities::Error],
                        [406, 'Invalid record', Entities::Error],
                        [404, 'Resource not found', Entities::Error]]
        params do
          optional :comment, type: String, desc: 'Comment on an entry'
        end
        put do
          entry = Entry.find params[:id]
          authorize entry, :put?
          entry.update!(declared_params)
          present entry, with: Entities::EntryDetailed
        end

        desc 'Delete an entry',
              success: Entities::EntryDetailed,
              failure: [[401, 'Unauthenticated access', Entities::Error],
                        [403, 'Forbidden access', Entities::Error],
                        [404, 'Resource not found', Entities::Error]]
        delete do
          entry = Entry.find params[:id]
          authorize entry, :delete?
          entry.destroy!
        end
      end
    end
  end
end
