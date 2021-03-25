require 'yaml'
class ConfigParser

  def initialize(path)
    @config = YAML.load_file(path)
    @routes = @config['routes']
    @default_response = @config['default_response']
    @backends = @config['backends']
  end

  def get_configs
    @config
  end

  def get_routes
    @routes
  end

  def get_default_response
    @default_response
  end

  def get_backends
    @backends
  end
end


