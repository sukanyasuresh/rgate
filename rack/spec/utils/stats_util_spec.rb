require_relative('../../app/utils/stats_util')

describe StatsUtil do
  context "Get the stats" do

    it "Should get the stats when the latency is of length > 2 with non zero n95, n99 values" do
      StatsUtil.add_to_errors
      StatsUtil.add_to_success
      StatsUtil.add_to_errors
      StatsUtil.add_to_success
      start_time = Time.now
      sleep(2)
      StatsUtil.calculate_stats(start_time, Time.now)
      stats_received = StatsUtil.get_stats
      expect(stats_received[:latency_ms][:average]).to_not eq(0)
      expect(stats_received[:latency_ms][:n95]).to_not eq(0)
      expect(stats_received[:latency_ms][:n99]).to_not eq(0)
    end

  end
end
