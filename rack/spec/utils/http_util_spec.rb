require_relative('../../app/utils/http_util')
require_relative('../../app/utils/stats_util')

describe HttpUtil do
  context "Get http response" do

    it "Should get the response array when the request is successful" do

      allow(StatsUtil).to receive(:add_to_success)
      response = Object.new

      response.define_singleton_method(:code) do
        200
      end
      response.define_singleton_method(:body) do
        {message: "success"}
      end

      allow(HttpUtil).to receive(:get).and_return(response)
      response = HttpUtil.http_get('test', 8070)
      expect(response).to eq([200, {"Content-Type" => 'application/json'}, [{message: "success"}]])
    end


    it "Should get the response array when the request fails" do

      allow(StatsUtil).to receive(:add_to_error)
      response = HttpUtil.http_get('test', 8070)
      expect(response).to eq([503, {"Content-Type" => 'application/json'}, [{:message => "Sorry, backend unavailable"}.to_json]])
    end
  end
end
