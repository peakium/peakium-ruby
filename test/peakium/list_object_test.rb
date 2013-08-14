require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class ListObjectTest < Test::Unit::TestCase
    should "be able to retrieve full lists given a listobject" do
      @mock.expects(:get).twice.returns(test_response(test_gateway_array))
      g = Peakium::Gateway.all
      assert g.kind_of?(Peakium::ListObject)
      assert_equal('/v1/gateways', g.endpoint_url)
      all = g.all
      assert all.kind_of?(Peakium::ListObject)
      assert_equal('/v1/gateways', all.endpoint_url)
      assert all.data.kind_of?(Array)
    end
  end
end