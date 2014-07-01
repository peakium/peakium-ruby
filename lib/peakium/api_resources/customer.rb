module Peakium
  class Customer < APIResource
    include Peakium::APIOperations::Create
    include Peakium::APIOperations::List
    include Peakium::APIOperations::Update

    def subscriptions
      Subscription.all({ :customer => id }, @api_key)
    end

    def subscription(token)
      subscription = Subscription.new(token, @api_key)
      subscription['customer'] = self
      subscription.refresh
      subscription
    end

    private

    def subscription_url(token)
      "#{subscriptions_url}/#{CGI.escape(token)}"
    end

    def subscriptions_url
      "#{endpoint_url}/subscriptions"
    end
  end
end
