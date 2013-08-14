module Peakium
  module APIOperations
    module Create
      module ClassMethods
        def create(params={}, api_key=nil)
          response, api_key = Peakium.request(:post, self.endpoint_url, api_key, params)
          Util.convert_to_peakium_object(response, api_key)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
