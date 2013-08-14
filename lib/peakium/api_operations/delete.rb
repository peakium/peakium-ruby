module Peakium
  module APIOperations
    module Delete
      def delete
        response, api_key = Peakium.request(:delete, endpoint_url, @api_key)
        refresh_from(response, api_key)
        self
      end
    end
  end
end
