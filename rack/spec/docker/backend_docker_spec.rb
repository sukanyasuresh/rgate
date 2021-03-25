require "serverspec"
require "docker"

describe "Orders Dockerfile" do
  before(:all) do
#     @image = Docker::Image.build_from_dir('./../containers/backend/orders')
#     @image.tag(repo: 'test/orders', tag: 'test')

#     set :os, family: :alpine
#     set :backend, :docker
#     set :docker_image, @image.id
  end


  xit "should have the right labels" do
    expect(@image.json["Config"]["Labels"].has_key?("app_name"))
    expect(@image.json["Config"]["Labels"].has_key?("environment"))
    expect(@image.json["Config"]["Labels"].has_key?("version"))
  end
end


describe "Payment Dockerfile" do
  before(:all) do
#     @image = Docker::Image.build_from_dir('./../containers/backend/payment')
#     @image.tag(repo: 'test/payment', tag: 'test')

#     set :os, family: :alpine
#     set :backend, :docker
#     set :docker_image, @image.id
  end

  xit "should have the right labels" do
    expect(@image.json["Config"]["Labels"].has_key?("app_name"))
    expect(@image.json["Config"]["Labels"].has_key?("environment"))
    expect(@image.json["Config"]["Labels"].has_key?("version"))
  end
end
