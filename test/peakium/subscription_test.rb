# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class SubscriptionTest < Test::Unit::TestCase
    should "subscriptions should be listable" do
      @mock.expects(:get).once.returns(test_response(test_subscription_array))
      s = Peakium::Subscription.all.data
      assert s.kind_of? Array
      assert s[0].kind_of? Peakium::Subscription
    end

    should "subscriptions should be deletable" do
      @mock.expects(:get).once.returns(test_response(test_customer))
      c = Peakium::Customer.retrieve("cu_test_customer")

      @mock.expects(:get).once.returns(test_response(test_subscription))
      s = c.subscription("test_subscription")

      @mock.expects(:delete).once.with("#{Peakium.api_base}/v1/customers/cu_test_customer/subscriptions/test_subscription", nil, nil).returns(test_response(test_subscription()))
      s.delete
    end
  end
end