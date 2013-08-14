# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Peakium
  class ApiResourceTest < Test::Unit::TestCase
    should "creating a new APIResource should not fetch over the network" do
      @mock.expects(:get).never
      g = Peakium::Gateway.new("someid")
    end

    should "creating a new APIResource from a hash should not fetch over the network" do
      @mock.expects(:get).never
      g = Peakium::Gateway.construct_from({
        :id => "somegateway",
        :object => "gateway"
      })
    end

    should "setting an attribute should not cause a network request" do
      @mock.expects(:get).never
      @mock.expects(:post).never
      g = Peakium::Gateway.new("gw_test_gateway");
      g.name = "Gateway Test";
    end

    should "accessing id should not issue a fetch over the network" do
      @mock.expects(:get).never
      g = Peakium::Gateway.new("gw_test_gateway");
      g.id
    end

    should "not specifying api credentials should raise an exception" do
      Peakium.api_key = nil
      assert_raises Peakium::AuthenticationError do
        Peakium::Gateway.new("gw_test_gateway").refresh
      end
    end

    should "specifying api credentials containing whitespace should raise an exception" do
      Peakium.api_key = "key "
      assert_raises Peakium::AuthenticationError do
        Peakium::Gateway.new("gw_test_gateway").refresh
      end
    end

    should "specifying invalid api credentials should raise an exception" do
      Peakium.api_key = "invalid"
      response = test_response(test_invalid_api_key_error, 401)
      assert_raises Peakium::AuthenticationError do
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 401))
        Peakium::Gateway.retrieve("gw_failing_gateway")
      end
    end

    should "AuthenticationErrors should have an http status, http body, and JSON body" do
      Peakium.api_key = "invalid"
      response = test_response(test_invalid_api_key_error, 401)
      begin
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 401))
        Peakium::Gateway.retrieve("gw_failing_gateway")
      rescue Peakium::AuthenticationError => e
        assert_equal(401, e.http_status)
        assert_equal(true, !!e.http_body)
        assert_equal(true, !!e.json_body[:error][:message])
        assert_equal(test_invalid_api_key_error['error']['message'], e.json_body[:error][:message])
      end
    end

    context "when specifying per-object credentials" do
      context "with no global API key set" do
        should "use the per-object credential when creating" do
          Peakium.expects(:execute_request).with do |opts|
            opts[:headers][:authorization] == 'Bearer sk_test_local'
          end.returns(test_response(test_gateway))

          Peakium::Gateway.create({:name => "test", :module => "test", :settings => []},
            'sk_test_local')
        end
      end

      context "with a global API key set" do
        setup do
          Peakium.api_key = "global"
        end

        teardown do
          Peakium.api_key = nil
        end

        should "use the per-object credential when creating" do
          Peakium.expects(:execute_request).with do |opts|
            opts[:headers][:authorization] == 'Bearer local'
          end.returns(test_response(test_gateway))

          Peakium::Gateway.create({:name => "test", :module => "test", :settings => []},
            'local')
        end

        should "use the per-object credential when retrieving and making other calls" do
          Peakium.expects(:execute_request).with do |opts|
            opts[:url] == "#{Peakium.api_base}/v1/gateways/gw_test_gateway" &&
              opts[:headers][:authorization] == 'Bearer local'
          end.returns(test_response(test_gateway))
          Peakium.expects(:execute_request).with do |opts|
            opts[:url] == "#{Peakium.api_base}/v1/gateways/gw_test_gateway/default" &&
              opts[:headers][:authorization] == 'Bearer local'
          end.returns(test_response(test_gateway))

          gw = Peakium::Gateway.retrieve('gw_test_gateway', 'local')
          gw.set_default
        end
      end
    end

    context "with valid credentials" do

      should "urlencode values in GET params" do
        response = test_response(test_payment_session_array)
        @mock.expects(:get).with("#{Peakium.api_base}/v1/payment_sessions?customer=test%20customer", nil, nil).returns(response)
        payment_sessions = Peakium::PaymentSession.all(:customer => 'test customer').data
        assert payment_sessions.kind_of? Array
      end

      should "construct URL properly with base query parameters" do
        response = test_response(test_invoice_customer_array)
        @mock.expects(:get).with("#{Peakium.api_base}/v1/invoices?customer=test_customer", nil, nil).returns(response)
        invoices = Peakium::Invoice.all(:customer => 'test_customer')

        @mock.expects(:get).with("#{Peakium.api_base}/v1/invoices?customer=test_customer&paid=true", nil, nil).returns(response)
        invoices.all(:paid => true)
      end

      should "a 400 should give an InvalidRequestError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 400)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Peakium::Gateway.retrieve("foo")
        rescue Peakium::InvalidRequestError => e
          assert_equal(400, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.kind_of?(Hash))
        end
      end

      should "a 401 should give an AuthenticationError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 401)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Peakium::Gateway.retrieve("foo")
        rescue Peakium::AuthenticationError => e
          assert_equal(401, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.kind_of?(Hash))
        end
      end

      should "a 404 should give an InvalidRequestError with http status, body, and JSON body" do
        response = test_response(test_missing_id_error, 404)
        @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))
        begin
          Peakium::Gateway.retrieve("foo")
        rescue Peakium::InvalidRequestError => e
          assert_equal(404, e.http_status)
          assert_equal(true, !!e.http_body)
          assert_equal(true, e.json_body.kind_of?(Hash))
        end
      end

      should "setting a nil value for a param should exclude that param from the request" do
        @mock.expects(:get).with do |url, api_key, params|
          uri = URI(url)
          query = CGI.parse(uri.query)
          (url =~ %r{^#{Peakium.api_base}/v1/gateways?} &&
           query.keys.sort == ['offset', 'sad'])
        end.returns(test_response({ :count => 1, :data => [test_gateway] }))
        g = Peakium::Gateway.all(:count => nil, :offset => 5, :sad => false)

        @mock.expects(:post).with do |url, api_key, params|
          url == "#{Peakium.api_base}/v1/gateways" && 
            api_key.nil? && 
            CGI.parse(params) == { 'name' => ['test'], 'module' => ['test'] }
        end.returns(test_response({ :count => 1, :data => [test_gateway] }))
        g = Peakium::Gateway.create(:name => "test", :module => "test", :settings => [])
      end

      should "requesting with a unicode ID should result in a request" do
        response = test_response(test_missing_id_error, 404)
        @mock.expects(:get).once.with("#{Peakium.api_base}/v1/gateways/%E2%98%83", nil, nil).raises(RestClient::ExceptionWithResponse.new(response, 404))
        g = Peakium::Gateway.new("☃")
        assert_raises(Peakium::InvalidRequestError) { g.refresh }
      end

      should "requesting with no ID should result in an InvalidRequestError with no request" do
        g = Peakium::Gateway.new
        assert_raises(Peakium::InvalidRequestError) { g.refresh }
      end

      should "making a GET request with parameters should have a query string and no body" do
        params = { :limit => 1 }
        @mock.expects(:get).once.with("#{Peakium.api_base}/v1/gateways?limit=1", nil, nil).returns(test_response([test_gateway]))
        g = Peakium::Gateway.all(params)
      end

      should "making a POST request with parameters should have a body and no query string" do
        params = { :name => 'Test gateway', :module => 'test' }
        @mock.expects(:post).once.with do |url, get, post|
          get.nil? && CGI.parse(post) == {'name' => ['Test gateway'], 'module' => ['test']}
        end.returns(test_response(test_gateway))
        g = Peakium::Gateway.create(params)
      end

      should "loading an object should issue a GET request" do
        @mock.expects(:get).once.returns(test_response(test_gateway))
        g = Peakium::Gateway.new("gw_test_gateway")
        g.refresh
      end

      should "using array accessors should be the same as the method interface" do
        @mock.expects(:get).once.returns(test_response(test_gateway))
        g = Peakium::Gateway.new("gw_test_gateway")
        g.refresh
        assert_equal g.created, g[:created]
        assert_equal g.created, g['created']
        g['created'] = 12345
        assert_equal g.created, 12345
      end

      should "accessing a property other than id or parent on an unfetched object should fetch it" do
        @mock.expects(:get).once.returns(test_response(test_customer))
        g = Peakium::Customer.new("test_cusotmer")
        g.subscriptions
      end

      should "updating an object should issue a POST request with only the changed properties" do
        @mock.expects(:post).with do |url, api_key, params|
          url == "#{Peakium.api_base}/v1/gateways/gw_test_gateway" && api_key.nil? && CGI.parse(params) == {'name' => ['another name']}
        end.once.returns(test_response(test_gateway))
        g = Peakium::Gateway.construct_from(test_gateway)
        g.name = "another name"
        g.save
      end

      should "updating should merge in returned properties" do
        @mock.expects(:post).once.returns(test_response(test_gateway))
        g = Peakium::Gateway.new("gw_test_gateway")
        g.name = "another name"
        g.save
        assert_equal false, g.livemode
      end

      should "deleting should send no props and result in an object that has no props other deleted" do
        @mock.expects(:get).never
        @mock.expects(:post).never
        @mock.expects(:delete).with("#{Peakium.api_base}/v1/webhooks/#{CGI.escape("http://example.com/webhook_endpoint/")}", nil, nil).once.returns(test_response({ "url" => "http\:\/\/example.com\/webhook_endpoint\/", "deleted" => true }))

        g = Peakium::Webhook.construct_from(test_webhook)
        g.delete
        assert_equal true, g.deleted

        assert_raises NoMethodError do
          g.livemode
        end
      end

      should "loading an object with properties that have specific types should instantiate those classes" do
        @mock.expects(:get).once.returns(test_response(test_gateway))
        g = Peakium::Gateway.retrieve("gw_test_gateway")
        assert g.module.kind_of?(Peakium::PeakiumObject) && g.module.object == 'gateway_module'
      end

      should "loading all of an APIResource should return an array of recursively instantiated objects" do
        @mock.expects(:get).once.returns(test_response(test_gateway_array))
        g = Peakium::Gateway.all.data
        assert g.kind_of? Array
        assert g[0].kind_of? Peakium::Gateway
        assert g[0].module.kind_of?(Peakium::PeakiumObject) && g[0].module.object == 'gateway_module'
      end

      context "error checking" do

        should "404s should raise an InvalidRequestError" do
          response = test_response(test_missing_id_error, 404)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 404))

          begin
            Peakium::Gateway.new("gw_test_gateway").refresh
            assert false #shouldn't get here either
          rescue Peakium::InvalidRequestError => e # we don't use assert_raises because we want to examine e
            assert e.kind_of? Peakium::InvalidRequestError
            assert_equal "id", e.param
            assert_equal "Missing id", e.message
            return
          end

          assert false #shouldn't get here
        end

        should "5XXs should raise an APIError" do
          response = test_response(test_api_error, 500)
          @mock.expects(:get).once.raises(RestClient::ExceptionWithResponse.new(response, 500))

          begin
            Peakium::Gateway.new("gw_test_gateway").refresh
            assert false #shouldn't get here either
          rescue Peakium::APIError => e # we don't use assert_raises because we want to examine e
            assert e.kind_of? Peakium::APIError
            return
          end

          assert false #shouldn't get here
        end
      end
    end
  end
end
