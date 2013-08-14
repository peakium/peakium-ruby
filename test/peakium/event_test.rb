# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class EventTest < Test::Unit::TestCase
    should "events should be listable" do
      @mock.expects(:get).once.returns(test_response(test_event_array))
      e = Peakium::Event.all.data
      assert e.kind_of? Array
      assert e[0].kind_of? Peakium::Event
    end

    should "be able to validate an event" do
      @mock.expects(:get).once.returns(test_response(test_event))
      e = Peakium::Event.retrieve("ev_test_event")

      @mock.expects(:post).once.with("#{Peakium.api_base}/v1/events/ev_test_event/validate", nil, e.to_json).returns(test_response(test_event()))
      e = e.validate(e.to_json);
    end


    should "be able to send/resend an event" do
      @mock.expects(:get).once.returns(test_response(test_event))
      e = Peakium::Event.retrieve("ev_test_event")

      @mock.expects(:post).once.with("#{Peakium.api_base}/v1/events/ev_test_event/send", nil, 'force=true').returns(test_response(test_event()))
      e = e.send({:force => true});
    end
  end
end