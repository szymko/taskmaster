require 'logger'
require 'singleton'
require 'fileutils'

class TaskLogger
  include Singleton

  def log(level: 'info', msg: '')
    build_logger() unless @logger
    @logger.send(level.to_sym) { msg }
  end

  def self.log(**args)
    self.instance.log(**args) if TaskmasterConfig[:logger][:enabled]
  end

  def self.log_exception(args)
    e = args[:exception]
    msg = args.except(:exception).to_json
    log(level: :error, msg: [e.to_s, msg, e.backtrace].join("\n"))
  end

  private

  def build_logger
    logger_path = File.join(PROJECT_ROOT, TaskmasterConfig[:logger][:file])
    FileUtils.touch(logger_path)
    @logger = Logger.new(logger_path)
  end
end
