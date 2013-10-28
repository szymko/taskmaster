class RobotsRetriever
  def initialize(robots)
    @robots = robots
  end

  def allowed?(uri, agent)
    @robots.parse()

    unless @robots.has?(uri.host)
      @robots.add(uri.host => Robot.find_by(host: uri.host))
    end

    @robots.allowed?(url: uri, agent: agent, empty: true)
  end

  def add_robots(host)
    @robots.get([host], raw: true)
    Robot.create(host: host, rules: @robots.raw[:host])
  end
end