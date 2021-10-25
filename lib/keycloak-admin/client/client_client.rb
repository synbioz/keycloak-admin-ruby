module KeycloakAdmin
  class ClientClient < Client
    def initialize(configuration, realm_client)
      super(configuration)
      raise ArgumentError.new("realm must be defined") unless realm_client.name_defined?
      @realm_client = realm_client
    end

    def list
      response = execute_http do
        RestClient::Resource.new(clients_url, @configuration.rest_client_options).get(headers)
      end
      JSON.parse(response).map { |client_as_hash| ClientRepresentation.from_hash(client_as_hash) }
    end

    def find_by_id(id)
      client_representations = list
      client_representations.select { |cr| cr.client_id == id }&.first
    end

    def roles(client_id)
      response = execute_http do
        RestClient::Resource.new(roles_url(client_id), @configuration.rest_client_options).get(headers)
      end
      JSON.parse(response).map { |role_as_hash| RoleRepresentation.from_hash(role_as_hash) }
    end

    def create_role(client_id, role_representation)
      execute_http do
        RestClient::Resource.new(roles_url(client_id), @configuration.rest_client_options).post(
          role_representation.to_json, headers
        )
      end
    end

    def find_role_by_name(client_id, role_name)
      response = execute_http do
        RestClient::Resource.new(roles_url(client_id) + "/#{role_name}", @configuration.rest_client_options).get(headers)
      end
      RoleRepresentation.from_hash(JSON.parse(response))
    end

    def delete_role_by_name(client_id, role_name)
      puts role_name
      response = execute_http do
        RestClient::Resource.new(roles_url(client_id) + "/#{role_name}", @configuration.rest_client_options).delete(headers)
      end
    end

    def clients_url(id=nil)
      if id
        "#{@realm_client.realm_admin_url}/clients/#{id}"
      else
        "#{@realm_client.realm_admin_url}/clients"
      end
    end

    def roles_url(client_id)
      @realm_client.realm_admin_url + "/clients/#{client_id}/roles"
    end
  end
end
