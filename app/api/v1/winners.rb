module V1
  class Winners < Base
    include ::Helpers::AuthHelpers

    # For admin only. Not part of requirements
    # This is just to make sense of the whole app's purpose.
    resource :winners do
      desc 'Get list of all winners',
            success: Entities::Winner,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error]]
      params do
        optional :per_page, default: 10, type: Integer, desc: 'Per page to return'
        optional :page, default: 1, type: Integer, desc: 'Page number to return'
      end
      get do
        authorize Winner, :get?
        present_collection Winner.all, with: Entities::Winner
      end

      desc 'Create a winner',
            success: Entities::Winner,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [406, 'No entries', Entities::Error],
                      [422, 'Validation error', Entities::Error]]
      params do
        requires :prize_id, type: Integer, desc: 'Prize ID of the winning entry that will be chosen from'
      end
      post do
        authorize Winner, :post?
        prize = Prize.find params[:prize_id]
        entries = prize.entries.where(won_at: nil)
        render_error!('invalid_record_error', 'No entries', 406) unless entries.any?
        winner = WinnerProcessor.new(entries, prize, current_user).process
        present winner, with: Entities::Winner
      end

      route_param :id do
        desc 'Get a winner by ID',
            success: Entities::Winner,
            failure: [[401, 'Unauthenticated access', Entities::Error],
                      [403, 'Forbidden access', Entities::Error],
                      [404, 'Resource not found', Entities::Error]]
        get do
          authorize Winner, :get?
          winner = Winner.find params[:id]
          present winner, with: Entities::Winner
        end
      end
    end
  end
end
