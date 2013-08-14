# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class CustomerTest < Test::Unit::TestCase
    should "gateways should be listable" do
      @mock.expects(:get).once.returns(test_response(test_gateway_array))
      g = Peakium::Gateway.all.data
      assert g.kind_of? Array
      assert g[0].kind_of? Peakium::Gateway
    end

    should "gateway should have GatewayModule objects associated with their module property" do
      @mock.expects(:get).once.returns(test_response(test_gateway))
      g = Peakium::Gateway.retrieve("gw_test_gateway")
      assert g.module.kind_of?(Peakium::PeakiumObject) && g.module.object == 'gateway_module'
    end

    should "gateways should be updateable" do
      @mock.expects(:get).once.returns(test_response(test_gateway({:mnemonic => "foo"})))
      @mock.expects(:post).once.returns(test_response(test_gateway({:mnemonic => "bar"})))
      g = Peakium::Gateway.new("test_gateway").refresh
      assert_equal g.mnemonic, "foo"
      g.mnemonic = "bar"
      g.save
      assert_equal g.mnemonic, "bar"
    end

    should "create should return a new gateway" do
      @mock.expects(:post).once.returns(test_response(test_gateway))
      g = Peakium::Gateway.create
      assert_equal "gw_test_gateway", g.id
    end
  end
end