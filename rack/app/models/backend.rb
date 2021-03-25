class Backend

  def initialize(name, port, route)
    @name = name
    @port = port
    @url_prefix = route
  end

  def set_name(name)
    @name = name
  end

  def get_name
    @name
  end

  def set_port(port)
    @port = port
  end

  def get_port
    @port
  end

  def set_url_prefix(url_prefix)
    @url_prefix = url_prefix
  end

  def get_url_prefix
    @url_prefix
  end

  def to_s
    puts "*********"
    puts "name: #{@name}"
    puts "path prefix: #{@url_prefix}"
    puts "running on port: #{@port}"
    puts "*********"
  end

end
