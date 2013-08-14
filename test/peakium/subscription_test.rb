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
  end
end