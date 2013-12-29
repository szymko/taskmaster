require_relative './../../spec_helper'

describe ObligatoryOptionalStrategy do

  describe "#parse" do

    let(:html_body) { "<html><body><h1>Header1</h1><div><p>Paragraph 1</p><p>Paragraph 2</p></div><h2>Header 2</h2></body></html>" }

    it "extracts text according to supplied paths" do
      @strat = ObligatoryOptionalStrategy.new(obligatory_path: "//h1", optional_path: "//p")
      expect(@strat.parse(html_body)).to eq(obligatory: "Header1", optional: "Paragraph 1.Paragraph 2")
    end

  end

end