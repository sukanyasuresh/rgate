require_relative('../../app/utils/config_parser')

describe ConfigParser do
  context "Get yml contents" do

    it "Should give the routes, default_response, backends" do

      cp = ConfigParser.new('config/test.yml')
      routes_received = cp.get_routes
      default_response_received = cp.get_default_response
      bacends_received = cp.get_backends

      config = YAML.load_file('config/test.yml')
      routes_expected = config['routes']
      default_response_expected = config['default_response']
      backends_expected = config['backends']

      expect(routes_received).to eq(routes_expected)
      expect(default_response_received).to eq(default_response_expected)
      expect(bacends_received).to eq(backends_expected)
    end
  end
end
