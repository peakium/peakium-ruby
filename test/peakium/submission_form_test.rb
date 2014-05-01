# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class SubmissionFormTest < Test::Unit::TestCase
    should "create should return a new submission form" do
      @mock.expects(:post).once.returns(test_response(test_submission_form))
      sf = Peakium::SubmissionForm.build('create_subscription', {:customer => "test_customer"})
      assert_equal "<form></form>", sf.html
    end
  end
end