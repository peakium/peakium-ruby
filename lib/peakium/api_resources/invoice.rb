module Peakium
  class Invoice < APIResource
    include Peakium::APIOperations::List
    include Peakium::APIOperations::Create

    def overdue(params={}, api_key = nil)
      params = params + { :overdue => true }
      all(params, api_key);
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
