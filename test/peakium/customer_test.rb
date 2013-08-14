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

    should "be able to cancel a customer's subscription" do
      @mock.expects(:get).once.returns(test_response(test_customer))
      c = Peakium::Customer.retrieve("test_customer")

      @mock.expects(:delete).once.with("#{Peakium.api_base}/v1/customers/test_customer/subscriptions/test_subscription", nil, nil).returns(test_response(test_subscription()))
      s = c.cancel_subscription('test_subscription');
    end
  end
end