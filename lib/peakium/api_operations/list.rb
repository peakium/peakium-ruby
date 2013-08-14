module Peakium
  module APIOperations
    module List
      module ClassMethods
        def all(filters={}, api_key=nil)
          response, api_key = Peakium.request(:get, endpoint_url, api_key, filters)
          object = Util.convert_to_peakium_object(response, api_key)

          # Set the URL for list objects
          if object.kind_of? ListObject
            object.set_endpoint_url(endpoint_url, filters)
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
