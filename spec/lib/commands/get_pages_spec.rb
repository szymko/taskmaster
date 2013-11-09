require_relative './../../spec_helper'
require_relative './../../spec_helper_model'

describe GetPages do
  describe "#perform" do
    it "calls #get on crawler" do
      cr = double(get: [])
      gp = GetPages.new(crawler: cr)

      gp.perform(pages: [])
      expect(cr).to have_received(:get).once
    end

    it "maps pages to urls" do
      cr = double(get: [])
      p = double(url: "http://www.example.com/")
      gp = GetPages.new(crawler: cr)

      gp.perform(pages: [p])
      expect(p).to have_received(:url).once
    end

    it "returns crawler" do
      cr = double(get: [])
      gp = GetPages.new(crawler: cr)

      expect(gp.perform(pages: [])).to eq(crawler: cr)
    end
  end
end
