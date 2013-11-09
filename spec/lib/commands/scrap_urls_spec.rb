require_relative './../../spec_helper'
require_relative './../../spec_helper_model'

describe ScrapUrls do
  describe "#perform" do
    it "calls #scrap on crawler" do
      cr = double(scrap: [])
      gp = ScrapUrls.new(pattern: /.*/)

      gp.perform(crawler: cr)
      expect(cr).to have_received(:scrap).with(/.*/).once
    end

    it "returns scrapped urls" do
      cr = double(scrap: ["https://www.example.com/"])
      gp = ScrapUrls.new(pattern: /.*/)

      expect(gp.perform(crawler: cr)).to eq(urls: ["https://www.example.com/"])
    end
  end
end
