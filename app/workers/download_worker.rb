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

#  def fetch(subset)
#    @page_update.fetch(subset: subset, number: 50)
#  end
#
#  def get(pages)
#    @crawler.get(pages.map(&:url))
#  end
#
#  def scrap(pattern)
#    @crawler.scrap(pattern)
#  end
#
#  def insert(urls)
#    @page_update.insert(urls: urls)
#  end
#
#  def update(pages)
#    @page_update.update(pages: pages, responses: @crawler.responses,
#                        errors: @crawler.errors)
#  end
#
  def inform()
    TaskLogger.log(level: :info, msg: @steps.pop)
  end
end
