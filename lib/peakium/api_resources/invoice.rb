module Peakium
  class Invoice < APIResource
    include Peakium::APIOperations::List

    def overdue(params, api_key = nil)
      response, api_key = Peakium.request(:get, overdue_url, api_key, params)
      Util.convert_to_peakium_object(response, api_key)
    end

    def pay
      response, api_key = Peakium.request(:post, pay_url, @api_key)
      refresh_from(response, api_key)
      self
    end

    private

    def overdue_url
      endpoint_url + '/overdue'
    end

    def pay_url
      endpoint_url + '/pay'
    end
  end
end
