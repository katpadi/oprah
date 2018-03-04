module V1
  module Entities
    class Winner < V1::Entities::Success
      expose :id, documentation: { type: :integer, desc: 'ID of winner' }
      expose :entry, using: V1::Entities::Entry, documentation: { type: V1::Entities::Entry, desc: 'Entry object associated to winner' }
      expose :prize, using: V1::Entities::Prize, documentation: { type: V1::Entities::Prize, desc: 'Prize object associated to winner' }
    end
  end
end
