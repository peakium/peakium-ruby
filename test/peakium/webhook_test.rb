# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class WebhookTest < Test::Unit::TestCase
    should "webhooks should be listable" do
      @mock.expects(:get).once.returns(test_response(test_webhook_array))
      w = Peakium::Webhook.all.data
      assert w.kind_of? Array
      assert w[0].kind_of? Peakium::Webhook
    end

    should "create should return a new webhook" do
      @mock.expects(:post).once.returns(test_response(test_webhook))
      w = Peakium::Webhook.create

      assert_equal "http://example.com/webhook_endpoint/", w.url
    end
  end
end