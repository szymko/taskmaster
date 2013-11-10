class GenericWorker

  attr_accessor :commands

  def initialize(name, commands)
    @name = name
    @commands = commands
  end

  def perform()
    TaskLogger.log(level: :debug, msg: "Starting #{@name} job.")
    shared = {}

    @commands.each do |c|
      msg = "Performing #{c.class.to_s}..."
      TaskLogger.log(level: :debug, msg: msg)
      shared.merge!(c.perform(shared))
    end

    TaskLogger.log(level: :debug, msg: "#{@name} job done.")
  end

end
