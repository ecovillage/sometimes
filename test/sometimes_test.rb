require "test_helper"

class SometimesTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sometimes::VERSION
  end
end
