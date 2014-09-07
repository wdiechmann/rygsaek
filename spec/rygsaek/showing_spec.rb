require 'spec_helper'

module Rygsaek
  describe Showing do
    describe "setting config local" do
      config1 = Rygsaek.configuration
      config2 = Rygsaek::Configuration.new
      config2.storage = :s3

      let(:storage_a) { Rygsaek::Showing.new(config1) }
      let(:storage_b) { Rygsaek::Showing.new(config2) }

      it "keeps configurations local if necessary" do
        expect(storage_a.config.storage).to eq(:file)
        expect(storage_b.config.storage).to eq(:s3)
      end        
    end
    
    describe "#view_photo" do
      let(:view_photo) { Rygsaek::Showing.new.view_a_photo }
      
      it "returns an empty string when no attachments exist" do
        expect(view_photo).to eq("")
      end
    end
  end
end