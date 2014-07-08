module Peakium
  class Subscription < APIResource
    include Peakium::APIOperations::List
    include Peakium::APIOperations::Update
    include Peakium::APIOperations::Delete

    def initialize(id=nil, api_key=nil)
      super(id, api_key)
      @values[:token] = id if id
    end

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
      unless customer = self['customer']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid #{Customer.class}: #{customer.inspect}", 'customer')
      end
      customer = Peakium::Customer.retrieve(customer, @api_key) if customer.is_a? String
      url = customer.endpoint_url + "/subscriptions/#{CGI.escape(id)}"
    end
  end
end
