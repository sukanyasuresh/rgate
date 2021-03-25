require 'docker'
require_relative('../models/backend')
require_relative('docker_util')
require_relative('route_util')

class BackendManager

  def initialize(port)
    @port = port
  end

  def get_backends(backend_configs, routes)
    backends = []
    backend_configs.map do |backend_config|
      backend = set_up_backend(backend_config, @port, routes)
      backends.append(backend)
      @port=@port+1
    end
    backends
  end


  private

  def set_up_backend(backend_config, port, routes)
    backend_name = backend_config['name']
    backend_labels = backend_config['match_labels']

    image = DockerUtil.get_image(backend_labels)

    if image

      image_name = image.info['RepoTags'][0]
      image_labels = image.info['Labels']
      puts "[INFO] Found the image for #{backend_name}: #{image_name} with labels: #{image_labels}"

      container = DockerUtil.get_container(image_name, port, 80)
      DockerUtil.start_container(container)

      puts "[INFO] Up and running a container for backend: #{backend_name}"

      url_prefix = RouteUtil.get_url_prefix(backend_name, routes)

      get_backend(backend_name, port, url_prefix)

    else
      puts "[ERROR] No matching image found for #{backend_name}"
    end
  end

  def get_backend(backend_name, port, route)
    Backend.new(backend_name, port, route)
  end
end
