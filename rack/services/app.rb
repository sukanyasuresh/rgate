require 'rack/utils'
require 'httparty'
require 'uri'
require_relative('api_gateway')
require_relative('./../app/utils/route_util')
require_relative('./../app/utils/docker_util')


# Reference: https://levelup.gitconnected.com/writing-a-small-web-service-with-ruby-rack-and-functional-programming-a16f802a19c0

#
# Get the configured backends
#

@path_prefix_matcher = ->(path) {->(env) {env['PATH_INFO'].include? path}}
@routes = []
@backends = []
@get_default_response = {}

def build_docker_images
  DockerUtil.build_image_from_dir('./../containers/backend/orders', 'orders', 'latest')
  DockerUtil.build_image_from_dir('./../containers/backend/payment', 'payment', 'latest')
end

def get_api_gateway
  file_path = ENV['CONFIG_PATH']
  @app = ApiGateway.new(file_path)
end

@app = get_api_gateway

def add_backends
  @app.set_up
  @backends = @app.get_backends
end

## Get all routes for the gateway

def add_routes
  @backends.map do |backend|
    url_perfix = backend.get_url_prefix
    handler = RouteUtil.get_route_handler_for_backend(backend)
    route = [@path_prefix_matcher[url_perfix], handler]
    @routes.append(route)
  end
end


## Get stats route

def add_stats_route
  stats_handler = RouteUtil.get_stats_handler
  stats_route = [@path_prefix_matcher['/stats'], stats_handler]
  @routes.append(stats_route)
end

## Get default route
def add_default_route
  default_response = @app.get_default_response
  not_found_handler = RouteUtil.get_not_found_handler(default_response)
  get_param = ->(x) {->(_) {x}}
  @routes.append([get_param.call(true), not_found_handler])
end

build_docker_images
add_backends
add_routes
add_stats_route
add_default_route

# Get the router based  on the path
get_lambda = ->(f1, f2) {->(x) {f1[f2[x]]}}
get_second_param = ->((_a, b)) {b}

route_matcher = ->(env) {->((route, _handler)) {route[env]}}
find_route = ->(env) {@routes.find(&route_matcher[env])}
find_handler = get_lambda[get_second_param, find_route]
router = ->(env) {find_handler[env][env]}

APP = router
