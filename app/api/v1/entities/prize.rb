module V1
  module Entities
    class Prize < V1::Entities::Success
      expose :id, documentation: { type: 'Integer', desc: 'ID of prize' }
      expose :name, documentation: { type: 'String', desc: 'Name of prize' }
      expose :description, documentation: { type: 'String', desc: 'Description of prize' }
      expose :created_at, documentation: { type: 'DateTime', desc: 'DateTime of prize' }
    end
  end
end
