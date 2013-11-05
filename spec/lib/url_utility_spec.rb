require_relative './../spec_helper'

describe UrlUtility do
  describe '.add_slash' do
    it { expect(UrlUtility.add_slash("http://www.e.com")).to eq("http://www.e.com/") }

    it { expect(UrlUtility.add_slash("http://www.e.com/")).to eq("http://www.e.com/") }
  end

  describe '.equal?' do
    it { expect(UrlUtility.equal?("http://www.e.com", "http://www.e.com")).to be_true }

    it { expect(UrlUtility.equal?("http://www.e.com", "http://www.e.com/")).to be_true }

    it { expect(UrlUtility.equal?("http://www.e.com", "http://www.f.com")).to be_false }
  end

  describe '.remove_fragment' do
    it { expect(UrlUtility.remove_fragment("http://www.e.com#1")).to eq("http://www.e.com") }
  end
end
