module V1
  module Entities
    class Entry < V1::Entities::Success
      expose :id, documentation: { type: :integer, desc: 'ID of entry' }
      expose :comment, documentation: { type: :string, desc: 'User comment on entry' }
      expose :created_at, documentation: { type: :datetime, desc: 'Creation timestamp' }
    end
  end
end
