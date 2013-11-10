require_relative './../spec_helper'

describe GenericWorker do

  describe "#perform" do
    it "uses supplied commands" do
      c1 = double(perform: {})
      worker = GenericWorker.new("test_worker", [c1])

      worker.perform()
      expect(c1).to have_received(:perform).once
    end

    it "allows to share state between commands" do
      c1 = double(perform: { result: 7 })
      c2 = double(perform: {})
      worker = GenericWorker.new("test_worker", [c1, c2])

      worker.perform()
      expect(c2).to have_received(:perform).with({ result: 7 }).once
    end

    it "logs progress" do
      c1 = double(perform: {})
      c2 = double(perform: {})
      allow(TaskLogger).to receive(:log)
      worker = GenericWorker.new("test_worker", [c1, c2])

      worker.perform()
      expect(TaskLogger).to have_received(:log).exactly(4).times
    end
  end
end
