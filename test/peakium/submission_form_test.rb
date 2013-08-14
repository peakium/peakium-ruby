# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class SubmissionFormTest < Test::Unit::TestCase
    should "create should return a new submission form" do
      @mock.expects(:post).once.returns(test_response(test_submission_form))
      sf = Peakium::SubmissionForm.build('create_subscription')
      assert_equal "<html></html>", sf.html
    end
  end
end