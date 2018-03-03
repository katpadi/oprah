module V1
  module Entities
    class EntryDetailed < V1::Entities::Entry
      expose :user, using: V1::Entities::User, documentation: { type: V1::Entities::User, desc: 'User object associated to entry' }
      expose :prize, using: V1::Entities::Prize, documentation: { type: V1::Entities::Prize, desc: 'Prize object associated to entry' }
    end
  end
end
