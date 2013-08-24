module Peakium
  class Gateway < APIResource
    include Peakium::APIOperations::Create
    include Peakium::APIOperations::List
    include Peakium::APIOperations::Update

    def set_default()
      response, api_key = Peakium.request(:post, set_default_url, @api_key)
      refresh_from(response, api_key)
      self
    end

    private

    def set_default_url
      endpoint_url + '/default'
    end
  end
end
