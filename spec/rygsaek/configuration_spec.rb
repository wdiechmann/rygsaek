require 'spec_helper'

module Rygsaek
  
  describe Configuration do
    
    describe "#storage" do
      it "defaults to :file" do
        Configuration.new.storage = :file
      end
    end
    
    describe "#storage=" do
      it "can set a storage value" do
        config = Configuration.new 
        config.storage=:s3
        expect(config.storage).to eq(:s3)
      end
    end
    
  end
  
end