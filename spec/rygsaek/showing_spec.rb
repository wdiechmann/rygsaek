require 'spec_helper'

module Rygsaek
  describe Showing do
    describe "#view_photo" do
      let(:view_photo) { Rygsaek::Showing.new.view_photo }
      
      it "returns an empty string when no attachments exist" do
        expect(view_photo).to eq("")
      end
    end
  end
end