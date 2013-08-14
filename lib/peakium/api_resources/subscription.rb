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
        raise InvalidRequestError.new("No token set for subscription", token)
      end
      unless customer = self['customer']
        raise InvalidRequestError.new("No customer set for subscription", customer)
      end
      url = customer.endpoint_url + "/#{self.class.endpoint_url}/#{CGI.escape(token)}"
    end
  end
end
