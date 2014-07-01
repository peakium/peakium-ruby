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
  end
end