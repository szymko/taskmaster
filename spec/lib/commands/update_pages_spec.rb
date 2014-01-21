require 'ostruct'
require_relative './../../spec_helper'
require_relative './../../spec_helper_model'

describe UpdatePages do

  context "given successful response" do

    describe "#perform" do

      it "updates page" do
        page = FactoryGirl.create(:page, status: "waiting")
        up = UpdatePages.new
        cr = crawler(responses: [response(url: page.url)])

        up.perform(pages: [page], crawler: cr)
        expect(page.status).to eq("success")
      end

      it "updates page_content" do
        page = FactoryGirl.create(:page, status: "waiting")
        up = UpdatePages.new
        cr = crawler(responses: [response(url: page.url)])

        up.perform(pages: [page], crawler: cr)

        expect(page.page_content.body).to eq(response.body)
        expect(page.page_content.status_code.to_i).to eq(response.status_code)
      end
    end
  end

  context "given error" do
    describe "#perform" do
      it "updates page" do
        page = FactoryGirl.create(:page, status: "waiting")
        up = UpdatePages.new
        cr = crawler(errors: [error(url: page.url)])

        up.perform(pages: [page], crawler: cr)
        expect(page.status).to eq("error")
      end

      it "recognizes error by status code" do
        page = FactoryGirl.create(:page, status: "waiting")
        up = UpdatePages.new
        cr = crawler(responses: [response(url: page.url, status_code: 500)])

        up.perform(pages: [page], crawler: cr)
        expect(page.status).to eq("error")
      end
    end
  end

  def crawler(responses: [], errors: [])
    double(responses: responses, errors: errors)
  end

  def response(url: "http://www.example.com", status_code: 200,
               body:"<html></html>", headers: "")
    OpenStruct.new(url: url, status_code: status_code, body: body, headers: headers)
  end

  def error(url: "http://www.example.com", details: "")
    OpenStruct.new(url: url, details: details)
  end
end
