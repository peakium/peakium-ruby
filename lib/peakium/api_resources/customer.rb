module Peakium
  class Customer < APIResource
    include Peakium::APIOperations::List

    def subscriptions
      Subscription.all({ :customer => id }, @api_key)
    end

    def cancel_subscription(token)
      response, api_key = Peakium.request(:delete, subscription_url(token), @api_key)
      refresh_from({ :subscription => response }, api_key, true)
      subscription
    end

    private

    def subscription_url(token)
      subscriptions_url + '/' + token
    end

    def subscriptions_url
      endpoint_url + '/subscriptions'
    end
  end
end
