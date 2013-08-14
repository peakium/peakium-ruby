module Peakium
  class APIResource < PeakiumObject
    def self.class_name
      self.name.split('::')[-1]
    end

    def self.endpoint_url()
      if self == APIResource
        raise NotImplementedError.new('APIResource is an abstract class. You should perform actions on its subclasses')
      end
      "/v1/#{CGI.escape(Util.camel_to_snake_case(class_name))}s"
    end

    def endpoint_url
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which endpoint URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.endpoint_url}/#{CGI.escape(id)}"
    end

    def refresh
      response, api_key = Peakium.request(:get, endpoint_url, @api_key, @retrieve_options)
      refresh_from(response, api_key)
      self
    end

    def self.retrieve(id, api_key=nil)
      instance = self.new(id, api_key)
      instance.refresh
      instance
    end
  end
end
