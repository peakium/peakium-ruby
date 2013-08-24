module Peakium
  class ListObject < PeakiumObject

    def [](k)
      case k
      when String, Symbol
        super
      else
        raise ArgumentError.new("You tried to access the #{k.inspect} index, but ListObject types only support String keys. (HINT: List calls return an object with a 'data' (which is the data array). You likely want to call #data[#{k.inspect}])")
      end
    end

    def each(&blk)
      self.data.each(&blk)
    end

    def all(params={}, api_key=nil)
      response, api_key = Peakium.request(:get, endpoint_url, api_key, params)
      Util.convert_to_peakium_object(response, api_key)
      self.set_endpoint_url(endpoint_url, params)
    end

    def set_endpoint_url(endpoint_url, params)
      # Set the URL for list objects
      url = endpoint_url;
      url += "#{(endpoint_url.include? '?') ? '&' : '?'}#{Peakium.uri_encode(params)}" if params && params.any?
      self.endpoint_url = url
      self
	end
  end
end
