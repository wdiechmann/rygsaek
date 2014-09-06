require "rygsaek/version"
require "rygsaek/showing"

# be prepared to rescue this
# pry will only be available to development
begin
  require "pry" 
rescue LoadError 
end

module Rygsaek
  # pry is available now
  # binding.pry
end
