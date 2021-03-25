class StatsUtil

  @success = 0
  @error = 0
  @latencies = []
  @average_latency = 0
  @p95 = 0
  @p99 = 0

  def self.get_percentile(values, percentile_value)
    values_sorted = values.sort
    k = (percentile_value * (values_sorted.length - 1) + 1).floor - 1
    f = (percentile_value * (values_sorted.length - 1) + 1).modulo(1)

    values_sorted[k] + (f * (values_sorted[k + 1] - values_sorted[k]))
  end

  def self.calculate_stats(start_time, end_time)
    @latencies.append(end_time - start_time)

    if @latencies.size > 1
      @average_latency = @latencies.inject(&:+).to_f / @latencies.size
      @p99 = get_percentile(@latencies, 0.99)
      @p95 = get_percentile(@latencies, 0.95)
    end
  end

  def self.get_stats
    {
        requests_count: {
            success: @success,
            error: @error,
        },
        latency_ms: {
            average: @average_latency,
            p95: @p95,
            p99: @p99
        }
    }

  end

  def self.add_to_success
    @success+=1
  end

  def self.add_to_errors
    @error+=1
  end

end
