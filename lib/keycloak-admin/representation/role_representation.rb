module KeycloakAdmin
  class RoleRepresentation < Representation
    attr_accessor :id,
      :name,
      :composite,
      :client_role

    def self.from_hash(hash)
      role             = new
      role.id          = hash["id"]
      role.name        = hash["name"]
      role.composite   = hash["composite"]
      role.client_role = hash["clientRole"]
      role
    end

    def to_post
      {
        "id" => id,
        "name" => name,
        "composite" => composite,
        "clientRole" => client_role
      }
    end
  end
end
