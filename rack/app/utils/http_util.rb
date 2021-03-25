require 'httparty'
class HttpUtil

  def self.get(url)
    HTTParty.get(url)
  end

  def self.http_get(container_path, port)
    start_time = Time.now
    begin
      response = self.get("http://localhost:#{port}/#{container_path}")
    rescue Errno::ECONNREFUSED
      StatsUtil.add_to_errors
      end_time = Time.now
      StatsUtil.calculate_stats(start_time, end_time)
      return [503, {"Content-Type" => 'application/json'}, [{:message => "Sorry, backend unavailable"}.to_json]]
    end
    StatsUtil.add_to_success
    end_time = Time.now
    StatsUtil.calculate_stats(start_time, end_time)
    [response.code, {"Content-Type" => 'application/json'}, [response.body]]
  end
end
