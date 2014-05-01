require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class UtilTest < Test::Unit::TestCase
    should "symbolize_names should convert names to symbols" do
      start = {
        'foo' => 'bar',
        'array' => [{ 'foo' => 'bar' }],
        'nested' => {
          1 => 2,
          :symbol => 9,
          'string' => nil
        }
      }
      finish = {
        :foo => 'bar',
        :array => [{ :foo => 'bar' }],
        :nested => {
          1 => 2,
          :symbol => 9,
          :string => nil
        }
      }

      symbolized = Peakium::Util.symbolize_names(start)
      assert_equal(finish, symbolized)
    end

    should "uri_encode should handle arrays correctly" do
      start = {
        'foo' => 'bar',
        'array' => [{ 'foo' => 'bar' }, {'foo' => 'bar 2'}],
      }
      finish = 'foo=bar&array[0][foo]=bar&array[1][foo]=bar%202'

      uri = Peakium.uri_encode(start)
      assert_equal(finish, uri)
    end
  end
end