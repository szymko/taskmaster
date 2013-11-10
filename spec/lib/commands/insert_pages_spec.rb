require_relative './../../spec_helper'
require_relative './../../spec_helper_model'

describe InsertPages do
  describe "#perform" do
    it { expect { subject.perform(urls: ["http://www.example.com/"]) }.to change{ Page.count }.by(1) }

    it { expect { subject.perform(urls: ["/example.com/"]) }.to_not change{ Page.count } }

    it { expect(subject.perform(urls: ["http://www.example.com/"])).to be_a(Hash)}

    it "performs validations" do
      FactoryGirl.create(:page, url: "http://www.s.com/")
      expect { subject.perform(urls: ["http://www.s.com/"]) }.to_not change { Page.count }
    end

    it "inserts unique urls" do
      expect { subject.perform(urls: Array.new(2, "http://www.s.co")) }.to change { Page.count }.by(1)
    end

    it "inserts new pages with `waiting` status" do
      url = "http://www.example.com/"
      subject.perform(urls: [url])
      expect(Page.find_by(url: url).status).to eq("waiting")
    end

    it "does not include fragments in urls" do
      url = "http://www.example.com/"
      expect { subject.perform(urls: [url, "#{url}#frag"]) }.to change { Page.count }.by(1)
    end
  end
end
