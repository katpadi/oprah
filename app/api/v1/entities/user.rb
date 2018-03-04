module V1
  module Entities
    class User < V1::Entities::Success
      expose :id, documentation: { type: 'Integer', desc: 'ID of user' }
      expose :name, documentation: { type: 'String', desc: 'Name of user' }
      expose :email, documentation: { type: 'String', desc: 'Email of user' }
    end
  end
end
