require_relative './../../spec_helper'
require_relative './../../spec_helper_model'

describe FetchPages do
  context "given db is empty" do
    describe "#perform" do
      it { expect(subject.perform()).to eq(pages: []) }
    end
  end

  context "given db is not empty" do
    describe "#perform" do
      it "performs requested number of pages" do
        5.times { FactoryGirl.create(:page, status: "waiting") }
        fp = FetchPages.new(number: 3)

        expect(fp.perform[:pages].length).to eq(3)
      end

      it "performs a specific page" do
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.example.com")
        fp = FetchPages.new(number: 1)

        expect(fp.perform()[:pages].first.url).to eq("http://www.example.com")
      end

      it "changes the status to 'running'" do
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.example.com")
        fp = FetchPages.new(number: 1)

        expect(fp.perform()[:pages].first.status).to eq("running")
      end

      it "performs from a subset" do
        FactoryGirl.create(:page, status: "waiting")
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.instance.com")
        subset = Page.where(url: "http://www.instance.com")
        fp = FetchPages.new(number: 2, subset: subset)

        expect(fp.perform()[:pages].length).to eq(1)
      end
    end

  end

end
