require 'spec_helper'
require 'rygsaek/helper'

class FakeView
  include Rygsaek::Helper
end

describe FakeView do
  describe "#view_photo" do
    it "delegates to Rygsaek::Showing#view_photo" do
      shower = double("Rygsaek::Showing")
      allow(Rygsaek::Showing).to receive(:new).and_return(shower)
      expect(shower).to receive(:view_a_photo)
      FakeView.new.view_photo
    end
  end
end