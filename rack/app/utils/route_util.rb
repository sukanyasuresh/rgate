
require_relative('./../utils/http_util')
require_relative('./../utils/stats_util')

class RouteUtil

  def self.get_url_prefix(backend_name, routes)
    routes.select {|route| route['backend'] == backend_name}[0]
  end

  def self.get_route_handler_for_backend(backend)
    port = backend.get_port
    handler = -> (env) {

      incoming_path = env['PATH_INFO']
      container_path = URI(incoming_path).path.split('/').last

      return HttpUtil.http_get(container_path, port)
    }
    handler

  end

  def self.get_stats_handler
    -> (_) {
          [200, {"Content-Type" => 'application/json'}, [StatsUtil.get_stats.to_json]]
        }
  end

  def self.get_not_found_handler(default_response)
    ->(_) {

      [default_response['status_code'],
       {"Content-Type" => 'application/json'},
       [{:message => default_response['body']}.to_json]]
    }

  end
end
