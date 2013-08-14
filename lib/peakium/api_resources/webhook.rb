module Peakium
  class Webhook < APIResource
    include Peakium::APIOperations::Create
    include Peakium::APIOperations::Delete
    include Peakium::APIOperations::List

    def id
      unless id = self['url']
        raise InvalidRequestError.new("No url set for Peakium::Webhook")
      end
      id
    end

    def endpoint_url
      unless id = self['url']
        raise InvalidRequestError.new("URL not set for webhook")
      end
      "#{self.class.endpoint_url}/#{CGI.escape(id)}"
    end
  end
end
