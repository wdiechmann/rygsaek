require 'spec_helper'

describe Rygsaek do
  
  describe ".reset" do
    before :each do
      Rygsaek.configure do |config|
        config.storage = :file
      end
    end
    
    it "resets the configuration" do
      Rygsaek.reset
      
      config = Rygsaek.configuration
      
      expect(config.storage).to eq(:file)
    end
  end
  
  describe "#configure" do
    
    before do
      Rygsaek.configure do |config|
        config.storage = :file
      end
    end
    
    it "returns :file as default storage type" do
      storage = Rygsaek.configuration.storage
      
      expect(storage).to eq(:file)
    end
  end
end