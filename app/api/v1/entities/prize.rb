module V1
  module Entities
    class Prize < V1::Entities::Success
      expose :id
      expose :name #, documentation: { type: "String", desc: "Name of prize" }
      expose :description #, documentation: { type: "String", desc: "Description of prize" }
      expose :created_at
    end
  end
end
