# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class PaymentSessionTest < Test::Unit::TestCase
    should "payment sessions should be listable" do
      @mock.expects(:get).once.returns(test_response(test_payment_session_array))
      ps = Peakium::PaymentSession.all.data
      assert ps.kind_of? Array
      assert ps[0].kind_of? Peakium::PaymentSession
    end
  end
end