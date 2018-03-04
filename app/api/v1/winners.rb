module V1
  class Winners < Base
    include ::Helpers::AuthHelpers

    # For admin only. Not part of requirements
    # This is just to make sense of the whole app's purpose.
    resource :winners do
      desc 'Get all winners'
      params do
        optional :per_page, default: 10, type: Integer, desc: 'Per page to return'
        optional :page, default: 1, type: Integer, desc: 'Page number to return'
      end
      get do
        authorize Prize, :get?
        present_collection Winner.all, with: Entities::Winner
      end

      desc 'Pick a winner'
      params do
        requires :prize_id, type: Integer, desc: 'Prize ID of the winning entry that will be chosen from'
      end
      post do
        prize = Prize.find params[:prize_id]
        entries = prize.entries.where(won_at: nil)
        render_error!('invalid_record_error', 'No entries', 406) unless entries.any?
        winner = WinnerProcessor.new(entries, prize, current_user).process
        present winner, with: Entities::Winner
      end

      route_param :id do
        desc 'Get a winner by ID'
        get do
          winner = Winner.find params[:id]
          present winner, with: Entities::Winner
        end
      end
    end
  end
end
