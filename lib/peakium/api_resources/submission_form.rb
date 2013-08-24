module Peakium
  class SubmissionForm < APIResource
    def self.build(type, params, api_key=nil)
      response, api_key = Peakium.request(:post, self.build_url(type), api_key, params)
      Util.convert_to_peakium_object(response, api_key)
    end

    def self.build_url(type)
      self.endpoint_url + '/' + type
    end
  end
end
