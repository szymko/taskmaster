require 'ostruct'
require_relative './../spec_helper'
require_relative './../spec_helper_model'

describe PageUpdate do

  context "given db is empty" do
    describe "#fetch" do
      it { expect(subject.fetch(number:10)).to eq([]) }
    end

    describe "#insert" do
      it { expect { subject.insert(urls: ["http://www.example.com/"]) }.to change{ Page.count }.by(1) }

      it { expect { subject.insert(urls: ["/example.com/"]) }.to_not change{ Page.count } }

      it "performs validations" do
        FactoryGirl.create(:page, url: "http://www.s.com/")
        expect { subject.insert(urls: ["http://www.s.com/"]) }.to_not change { Page.count }
      end

      it "inserts unique urls" do
        expect { subject.insert(urls: Array.new(2, "http://www.s.co")) }.to change { Page.count }.by(1)
      end

      it "adds slashes to urls" do
        subject.insert(urls: ["http://www.s.com"])
        expect(Page.last.url).to eq("http://www.s.com/")
      end
    end
  end

  context "given db is not empty" do
    describe "#fetch" do
      it "fetches requested number of pages" do
        5.times { FactoryGirl.create(:page, status: "waiting") }
        page_update = PageUpdate.new

        expect(page_update.fetch(number: 3).length).to eq(3)
      end

      it "fetches a specific page" do
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.example.com")
        page_update = PageUpdate.new

        expect(page_update.fetch(number: 1).first.url).to eq("http://www.example.com")
      end

      it "changes the status to 'running'" do
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.example.com")
        page_update = PageUpdate.new

        expect(page_update.fetch(number: 1).first.status).to eq("running")
      end

      it "fetches from a subset" do
        FactoryGirl.create(:page, status: "waiting")
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.instance.com")
        page_update = PageUpdate.new
        subset = Page.where(url: "http://www.instance.com")

        expect(page_update.fetch(number: 2, subset: subset).length).to eq(1)
      end
    end
  end

  context "given successful response" do

    describe "#update" do

      it "updates page" do
        page = FactoryGirl.create(:page, status: "waiting")
        page_update = PageUpdate.new

        page_update.update(pages: [page], responses: [response(url: page.url)])
        expect(page.status).to eq("success")
      end

      it "updates page_content" do
        page = FactoryGirl.create(:page, status: "waiting")
        page_update = PageUpdate.new
        response = response(url: page.url)

        page_update.update(pages: [page], responses: [response])

        expect(page.page_content.body).to eq(response.body)
        expect(page.page_content.status_code).to eq(response.status_code)
      end
    end
  end

  context "given error" do
    describe "#update" do
      it "updates page" do
        page = FactoryGirl.create(:page, status: "waiting")
        page_update = PageUpdate.new

        page_update.update(pages: [page], errors: [error(url: page.url)])
        expect(page.status).to eq("error")
      end
    end
  end

  def response(url: "http://www.example.com", status_code: 200,
               body:"<html></html>", headers: "")
    OpenStruct.new(url: url, status_code: status_code, body: body, headers: headers)
  end

  def error(url: "http://www.example.com", details: "")
    OpenStruct.new(url: url, details: details)
  end
end
