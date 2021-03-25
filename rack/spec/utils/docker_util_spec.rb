require_relative('../../app/utils/docker_util')

describe DockerUtil do
  context "Get docker container params" do

    it "Should return constructed docker params" do
      ENV['environment'] = 'test'
      image_name = 'test_image'
      host_port = 8080
      container_port = 80
      params = DockerUtil.get_container_params(image_name, host_port, container_port)
      expect(params).to eq({:Env=>  ["environment=test"], :ExposedPorts=>{:"80/tcp"=>{}}, :HostConfig=>{:PortBindings=>{:"80/tcp"=>[{:HostPort=>"8080"}]}}, :Image=>"test_image"})
    end

    it "Should return image if config labels match container labels" do
      image = Object.new
      image.define_singleton_method(:info) do
        info = {}
        docker_labels = {:env => "test", :name => "test_backend", :other => "to be ignore"}
        info['Labels'] = docker_labels
        info
      end

      image.define_singleton_method(:name) do
        "TEST_CONTAINER"
      end
      allow(DockerUtil).to receive(:get_all_docker_images).and_return([image])
      image_received = DockerUtil.get_image({:env => "test", :name => "test_backend", :other => "to be ignore"})
      expect(image_received.name).to eq( "TEST_CONTAINER")
    end
  end
end
