# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class InvoiceTest < Test::Unit::TestCase
    should "invoices should be listable" do
      @mock.expects(:get).once.returns(test_response(test_invoice_array))
      i = Peakium::Invoice.all.data
      assert i.kind_of? Array
      assert i[0].kind_of? Peakium::Invoice
    end

    should "be able to attempt payment of an invoice" do
      @mock.expects(:get).once.returns(test_response(test_invoice))
      i = Peakium::Invoice.retrieve("in_test_invoice")

      @mock.expects(:post).once.with("#{Peakium.api_base}/v1/invoices/in_test_invoice/pay", nil, '').returns(test_response(test_invoice()))
      i = i.pay;
    end
  end
end