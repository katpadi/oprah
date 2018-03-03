module V1
  module Entities
    class User < V1::Entities::Success
      expose :id
      expose :name #, documentation: { type: "String", desc: "Name of prize" }
    end
  end
end
