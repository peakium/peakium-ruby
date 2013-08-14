# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class EventWebhookTest < Test::Unit::TestCase
    should "event webhooks should be listable" do
      @mock.expects(:get).once.returns(test_response(test_event_webhook_array))
      ew = Peakium::EventWebhook.all.data
      assert ew.kind_of? Array
      assert ew[0].kind_of? Peakium::EventWebhook
    end
  end
end