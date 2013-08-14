module Peakium
  class Event < APIResource
    include Peakium::APIOperations::List

    def validate(data)
      response, api_key = Peakium.request(:post, validate_url, @api_key, data)
      refresh_from(response, api_key)
      self
    end

    def send(params={})
      response, api_key = Peakium.request(:post, send_url, @api_key, params)
      refresh_from(response, api_key)
      self
    end

    private

    def validate_url
      endpoint_url + '/validate'
    end

    def send_url
      endpoint_url + '/send'
    end

  end
end
