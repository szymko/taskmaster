class DownloadWorker

  attr_accessor :commands

  def initialize(commands)
    @commands = commands
  end

  def perform()
    TaskLogger.log(level: :debug, msg: "Starting DownloadWorker job.")
    shared = {}

    @commands.each do |c|
      msg = "Performing #{c.class.to_s}..."
      TaskLogger.log(level: :debug, msg: msg)
      shared.merge!(c.perform(shared))
    end

    TaskLogger.log(level: :debug, msg: "DownloadWorker job done.")
  end

  private

  def inform()
    TaskLogger.log(level: :info, msg: @steps.pop)
  end
end
