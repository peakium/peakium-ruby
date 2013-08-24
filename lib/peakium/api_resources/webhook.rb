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
      unless url = self['url']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid url: #{url.inspect}", 'url')
      end
      "#{self.class.endpoint_url}/#{CGI.escape(url)}"
    end
  end
end
