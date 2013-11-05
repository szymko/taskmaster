require_relative './../spec_helper'

describe DownloadWorker do
  context "when performing job" do
    describe ".perform" do
      it "uses PageUpdate and Crawler" do
        page =  FactoryGirl.build(:page, url: 'http://en.wikipedia.org/')
        res = response
        crawl =  crawler(scrap: ["http://www.e.com"], responses: [res], errors: [])
        pu = page_update(fetch: [page])
        worker = DownloadWorker.new(page_update: pu, crawler: crawl)

        worker.perform(subset: Page.wiki, pattern: /.*/)
        expect(pu).to have_received(:fetch).with({ subset: Page.wiki, number: 50})
        expect(pu).to have_received(:insert).with(urls: ["http://www.e.com"])
        expect(pu).to have_received(:update).with(pages: [page],
                                                  responses: [res],
                                                  errors: [])
      end

    end
  end

  def page_update(opts = {})
    opts = { fetch: [], insert: [], update: [] }.merge(opts)
    double("page_update", opts)
  end

  def crawler(opts = {})
    opts = { get: nil, scrap: [], responses: [], errors: [], urls: [] }.merge(opts)
    double("crawler", opts)
  end

  def response(opts = {})
    double("response", opts)
  end
end
