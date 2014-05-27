module Peakium
  class Subscription < APIResource
    include Peakium::APIOperations::List
    include Peakium::APIOperations::Update
    include Peakium::APIOperations::Delete

    def id
      unless id = self['token']
        raise InvalidRequestError.new("Object #{self.class} has not token: #{id.inspect}", id)
      end
      id
    end

    def self.retrieve(id, api_key=nil)
      raise InvalidRequestError.new("You need to access individual #{self.class} through a #{Customer.class}", 'customer');
    end

    def endpoint_url
      unless token = self['token']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid token: #{token.inspect}", 'token')
      end
      unless customer = self['customer']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid #{Customer.class}: #{customer.inspect}", 'customer')
      end
      url = customer.endpoint_url + "/subscriptions/#{CGI.escape(token)}"
    end
  end
end
