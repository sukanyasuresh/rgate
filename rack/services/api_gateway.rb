require_relative('../app/utils/config_parser')
require_relative('../app/utils/backend_manager')

class ApiGateway

  def initialize(config)
    @config = config
    @backends = []
    @default_response = {}
  end

  def get_backends
    @backends
  end

  def set_up
    config_parser = ConfigParser.new(@config)
    backends_configs = config_parser.get_backends
    routes = config_parser.get_routes
    @default_response = config_parser.get_default_response
    backend_manager = BackendManager.new(8000)
    @backends = backend_manager.get_backends(backends_configs, routes)

    puts "[INFO] All matching containers created and running."

    @backends.map do |backend|
      name = backend.get_name
      route = routes.select {|route| route['backend'] == name}[0]
      if route
        backend.set_url_prefix(route['path_prefix'])
      end
    end

    puts "[INFO] Configured backends:"
    @backends.map(&:to_s)

  end

  def get_default_response
    @default_response
  end

end
