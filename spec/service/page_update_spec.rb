require 'ostruct'
require_relative './../spec_helper'
require_relative './../spec_helper_model'

#p = PageUpdate.new()
#pages = p.fetch(number: 10)
#p.update(pages: pages, responses: responses, errors: errors, context: "wikipedia")
#p.insert(urls: new_urls)

describe PageUpdate do

  context "given db is empty" do
    describe "#fetch" do
      it { expect(subject.fetch(number:10)).to eq([]) }
    end

    describe "#insert" do
      it { expect(subject.insert(urls: ["http://www.example.com/"])).to change{ Page.count }.by(1) }
    end
  end

  context "given db is not empty" do
    describe "#fetch" do
      it "fetches requested number of pages" do
        5.times { FactoryGirl.create(:page, status: "waiting") }
        pu = PageUpdate.new

        expect(pu.fetch(number: 3).length).to eq(3)
      end

      it "fetches a specific page" do
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.example.com")
        pu = PageUpdate.new

        expect(pu.fetch(number: 1).first.url).to eq("http://www.example.com")
      end

      it "changes the status to 'running'" do
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.example.com")
        pu = PageUpdate.new

        expect(pu.fetch(number: 1).first.status).to eq("running")
      end

      it "fetches from a subset" do
        FactoryGirl.create(:page, status: "waiting")
        FactoryGirl.create(:page, status: "waiting",
                            url: "http://www.instance.com")
        pu = PageUpdate.new
        subset = Page.where(url: "http://www.instance.com")

        expect(pu.fetch(number: 2, subset: subset).length).to eq(1)
      end
    end
  end

  context "given successful response" do

    describe "#update" do

      it "updates page" do
        p = FactoryGirl.create(:page, status: "waiting")
        pu = PageUpdate.new

        pu.update(pages: p, responses: response(url: p.url), context: "test")
        expect(p.status).to eq("success")
        expect(p.scrapping_contexts.first.name).to eq("test")
      end

      it "updates page_content" do
        p = FactoryGirl.create(:page, status: "waiting")
        pu = PageUpdate.new
        r = response(url: p.url)

        pu.update(pages: p, responses: r, context: "test")
        pc = page.scrapping_contexts.first.page_contents.first

        expect(pc.body).to eq(r.body)
        expect(pc.status_code).to eq(r.status_code)
      end
    end
  end

  context "given error" do
    describe "#update" do
      it "updates page" do
        p = FactoryGirl.create(:page, status: "waiting")
        pu = PageUpdate.new

        pu.update(pages: p, errors: error(url: p.url), context: "test")
        expect(p.status).to eq("error")
        expect(ScrappingContext.count).to eq(0)
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
