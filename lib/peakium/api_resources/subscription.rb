module Peakium
  class Subscription < APIResource
    include Peakium::APIOperations::List

    def id
      unless id = self['token']
        raise InvalidRequestError.new("No token set for Peakium::Webhook")
      end
      id
    end

    def endpoint_url
      unless token = self['id']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid token: #{token.inspect}", 'token')
      end
      unless customer = self['customer']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid #{Customer.class}: #{customer.inspect}", 'customer')
      end
      url = customer.endpoint_url + "/subscriptions/#{CGI.escape(token)}"
    end
  end
end
