require 'peakium'
require 'test/unit'
require 'mocha/setup'
require 'shoulda'
require 'stringio'

#monkeypatch request methods
module Peakium
  @mock_rest_client = nil

  def self.mock_rest_client=(mock_client)
    @mock_rest_client = mock_client
  end

  def self.execute_request(opts)
    get_params = (opts[:headers] || {})[:params]
    post_params = opts[:payload]
    case opts[:method]
    when :get then @mock_rest_client.get opts[:url], get_params, post_params
    when :post then @mock_rest_client.post opts[:url], get_params, post_params
    when :delete then @mock_rest_client.delete opts[:url], get_params, post_params
    end
  end
end

def test_response(body, code=200)
  # When an exception is raised, restclient clobbers method_missing.  Hence we
  # can't just use the stubs interface.
  body = MultiJson.dump(body) if !(body.kind_of? String)
  m = mock
  m.instance_variable_set('@peakium_values', { :body => body, :code => code })
  def m.body; @peakium_values[:body]; end
  def m.code; @peakium_values[:code]; end
  m
end

def test_charge
  {
    :livemode => false,
    :object => "charge",
    :amount => 7200,
    :currency => "USD",
    :paid => true,
    :timestamp_paid => 1375217068,
    :status => "completed",
  }
end

def test_customer(params={})
  {
    :livemode => false,
    :object => "customer",
    :id => "test_customer",
    :created => 1375217068,
    :balances => [],
  }.merge(params)
end

def test_customer_array
  {
    :data => [test_customer, test_customer, test_customer],
    :object => 'list'
  }
end

def test_event(params={})
  {
    :livemode => false,
    :object => "event",
    :id => "ev_test_event",
    :created => 1375217068,
    :event => "subscription_created",
    :data => test_subscription,
  }.merge(params)
end

def test_event_array
  {
    :data => [test_event, test_event, test_event],
    :object => 'list'
  }
end

def test_event_webhook()
  {
    :livemode => false,
    :object => "event_webhook",
    :created => 1375217068,
    :number_of_attempted_deliveries => 1,
    :delivered => true,
    :delivered_timestamp => 1375217068,
    :webhook => test_webhook,
    :event => test_event
  }
end

def test_event_webhook_array
  {
    :data => [test_event_webhook, test_event_webhook, test_event_webhook],
    :object => 'list'
  }
end

def test_gateway(params={})
  {
    :livemode => false,
    :object => "gateway",
    :id => "gw_test_gateway",
    :created => 1375217068,
    :name => "Paypal",
    :active => true,
    :default => false,
    :module => {
      :object => "gateway_module",
      :name => "Paypal_Website_Payments_Standard",
      :required_fields => [
        "paypal_email"
      ]
    },
    :settings => [
      :paypal_email => "paypal@example.com"
    ]
  }.merge(params)
end

def test_gateway_array
  {
    :data => [test_gateway, test_gateway, test_gateway],
    :object => 'list'
  }
end

def test_invoice
  {
    :livemode => false,
    :object => "invoice",
    :id => "in_test_invoice",
    :created => 1375217068,
    :due => 1375217068,
    :locked => true,
    :timestamp_locked => 1375217068,
    :paid => true,
    :timestamp_paid => 1375217068,
    :retracted => true,
    :timestamp_retracted => 1375217068,
    :type => "single",
    :calculated_total => {
      :currency => "USD",
      :amount => 7200
    },
    :attempt_automatic_charge => true,
    :items => [
      {
          :livemode => false,
          :object => "invoice_item",
          :type => "credit",
          :description => "Plus Plan",
          :item_id => 101,
          :unit_amount => 7200,
          :currency => "USD",
          :quantity => 1,
          :date_range_start => 1375217068,
          :date_range_end => 1375217068,
          :discount => 0.0,
          :total_amount => 7200,
          :reference => test_subscription
      }
    ],
    :customer => test_customer
  }
end

def test_invoice_array
  {
    :data => [test_invoice, test_invoice, test_invoice],
    :object => 'list'
  }
end

def test_overdue_invoice_array
  {
    :data => [test_invoice],
    :object => 'list'
  }
end

def test_invoice_customer_array
  {
    :data => [test_invoice],
    :object => 'list'
  }
end

def test_payment_session
  {
    :livemode => false,
    :object => "payment_session",
    :id => "ps_test_payment_session",
    :created => 1375217068,
    :handled => true,
    :timestamp_handled => 1375217068,
    :locked => true,
    :payment_amount => 7200,
    :payment_currency => "USD",
    :action => "subscription-update",
    :ip => "172.16.254.1",
    :user_agent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36",
    :type => "single",
    :posted_values => {
      :customer => "test_customer",
      :subscription => "test_subscription",
      :item_description => "Test Subscription",
      :item_id => 101,
      :period_amount => 1,
      :period_type => "month",
      :payment_amount => 7200,
      :payment_currency => "USD",
      :payment_discount => "USD",
      :return_url_ok => "USD",
      :return_url_error => "USD",
      :publishable_key => "test_publishable_key",
      :gateway => "gw_test_gateway",
      :integrity_value => "test_integrity",
    },
    :gateway => test_gateway,
    :customer => test_customer,
    :charge => test_charge
  }
end

def test_payment_session_array
  {
    :data => [test_payment_session, test_payment_session, test_payment_session],
    :object => 'list'
  }
end

def test_subscription()
  {
    :livemode => false,
    :object => "subscription",
    :created => 1375217068,
    :token => "test_subscription",
    :display_name => "Test Subscription",
    :plan => {
      :period_amount => 1,
      :period_type => "month",
      :amount => 7200,
      :currency => "USD",
      :discount => 0.0,
      :item_id => 101,
    },
    :cycle_number => 1,
    :period_start => 1375217068,
    :period_end => 1375217068,
    :next_charge => 1375217068,
    :status => "active",
    :customer => test_customer
  }
end

def test_subscription_array
  {
    :data => [test_subscription, test_subscription, test_subscription],
    :object => 'list'
  }
end

def test_subcription_customer_array
  {
    :data => [test_subscription],
    :object => 'list'
  }
end

def test_submission_form
  {
    :livemode => false,
    :html => "<html></html>"
  }
end

def test_webhook
  {
    :object => "webhook",
    :url => "http://example.com/webhook_endpoint/",
  }
end

def test_webhook_array
  {
    :data => [test_webhook, test_webhook, test_webhook],
    :object => 'list'
  }
end

def test_invalid_api_key_error
  {
    "error" => {
      "type" => "invalid_request_error",
      "message" => "Invalid API Key provided: invalid"
    }
  }
end

def test_missing_id_error
  {
    :error => {
      :param => "id",
      :type => "invalid_request_error",
      :message => "Missing id"
    }
  }
end

def test_api_error
  {
    :error => {
      :type => "api_error"
    }
  }
end

class Test::Unit::TestCase
  include Mocha

  setup do
    @mock = mock
    Peakium.mock_rest_client = @mock
    Peakium.api_key="foo"
  end

  teardown do
    Peakium.mock_rest_client = nil
    Peakium.api_key=nil
  end
end