module V1
  class Winners < Base

    resource :winners do
      desc 'Get all winners'
      get do
        Winner.all
      end

      route_param :id do
        desc 'Get a winner by ID'
        get do
          entry = Winner.find(params[:id])
          entry
        end

        # For admin only!!!
        desc 'Pick a winner'
        params do
          requires :prize_id, type: Integer
        end
        post do
          Winner.create! declared_params
        end
      end
    end
  end
end
