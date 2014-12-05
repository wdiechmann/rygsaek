require 'test_helper'

module Rygsaek
  def self.yield_and_restore
  #   @@warden_configured = nil
  #   c, b = @@warden_config, @@warden_config_blocks
  #   yield
  # ensure
  #   @@warden_config, @@warden_config_blocks = c, b
  end
end

class RygsaekTest < ActiveSupport::TestCase
  test 'bcrypt on the class' do
    password = "super secret"
    klass    = Struct.new(:pepper, :stretches).new("blahblah", 2)
    hash     = Rygsaek.bcrypt(klass, password)
    assert_equal ::BCrypt::Password.create(hash), hash

    klass    = Struct.new(:pepper, :stretches).new("bla", 2)
    hash     = Rygsaek.bcrypt(klass, password)
    assert_not_equal ::BCrypt::Password.new(hash), hash
  end

  # test 'model options can be configured through Rygsaek' do
  #   swap Rygsaek, allow_unconfirmed_access_for: 113, pepper: "foo" do
  #     assert_equal 113, Devise.allow_unconfirmed_access_for
  #     assert_equal "foo", Devise.pepper
  #   end
  # end

  test 'setup block yields self' do
    Rygsaek.setup do |config|
      assert_equal Rygsaek, config
    end
  end

  test 'add new module using the helper method' do
    assert_nothing_raised(Exception) { Rygsaek.add_module(:coconut) }
    assert_equal 1, Rygsaek::ALL.select { |v| v == :coconut }.size
    assert_not Rygsaek::STRATEGIES.include?(:coconut)
    assert_not defined?(Rygsaek::Models::Coconut)
    Rygsaek::ALL.delete(:coconut)

    assert_nothing_raised(Exception) { Rygsaek.add_module(:banana, strategy: :fruits) }
    assert_equal :fruits, Rygsaek::STRATEGIES[:banana]
    Rygsaek::ALL.delete(:banana)
    Rygsaek::STRATEGIES.delete(:banana)

    assert_nothing_raised(Exception) { Rygsaek.add_module(:kivi, controller: :fruits) }
    assert_equal :fruits, Rygsaek::CONTROLLERS[:kivi]
    Rygsaek::ALL.delete(:kivi)
    Rygsaek::CONTROLLERS.delete(:kivi)
  end

  test 'should complain when comparing empty or different sized passes' do
    [nil, ""].each do |empty|
      assert_not Rygsaek.secure_compare(empty, "something")
      assert_not Rygsaek.secure_compare("something", empty)
      assert_not Rygsaek.secure_compare(empty, empty)
    end
    assert_not Rygsaek.secure_compare("size_1", "size_four")
  end

end
