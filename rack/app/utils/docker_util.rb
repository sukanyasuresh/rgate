require 'docker'

class DockerUtil
  def self.get_image(backend_labels)
    images = self.get_all_docker_images
    images.filter do |image|
      labels = image.info['Labels']
      if labels
        if backend_labels <= labels
          return image
        end
      end
    end
  end

  def self.get_container_params(image_name, host_port, container_port)
    {
        Image: image_name,
        ExposedPorts: {
            "#{container_port}/tcp": {}
        },
        HostConfig: {
            PortBindings: {
                "#{container_port}/tcp": [
                    {
                        HostPort: host_port.to_s
                    }
                ]
            }
        },
        Env: ["environment=#{ENV['environment']}"]
    }
  end

  def self.get_container(image_name, host_port, container_port)

    container_params = self.get_container_params(image_name, host_port, container_port)
    container = Docker::Container.create(container_params)
    container
  end

  def self.start_container(container)
    container.start
  end

  def self.get_all_docker_images
    Docker::Image.all
  end

  def self.build_image_from_dir(path, repo, tag)
    image = Docker::Image.build_from_dir(path)
    image.tag(repo: repo, tag: tag)
  end
end
