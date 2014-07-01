# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class CustomerTest < Test::Unit::TestCase
    should "customers should be listable" do
      @mock.expects(:get).once.returns(test_response(test_customer_array))
      c = Peakium::Customer.all.data
      assert c.kind_of? Array
      assert c[0].kind_of? Peakium::Customer
    end

    should "create should return a new customer" do
      @mock.expects(:post).once.returns(test_response(test_customer))
      g = Peakium::Customer.create
      assert_equal "cu_test_customer", g.id
    end

    should "subscription fetched with nested resource" do
      @mock.expects(:get).once.returns(test_response(test_customer))
      c = Peakium::Customer.retrieve("cu_test_customer")

      @mock.expects(:get).once.returns(test_response(test_subscription))
      s = c.subscription("test_subscription")
      assert_equal('/v1/customers/cu_test_customer/subscriptions/test_subscription', s.endpoint_url)
    end
  end
end