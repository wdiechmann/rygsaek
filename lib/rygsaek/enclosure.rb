module Rygsaek
  module Enclosure
    def self.has_enclosures
      has_many :attachables
    end
  end
end