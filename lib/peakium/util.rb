module Peakium
  module Util
    def self.objects_to_ids(h)
      case h
      when APIResource
        h.id
      when Hash
        res = {}
        h.each { |k, v| res[k] = objects_to_ids(v) unless v.nil? }
        res
      when Array
        h.map { |v| objects_to_ids(v) }
      else
        h
      end
    end

    def self.object_classes
      @object_classes ||= {
        'customer' => Customer,
        'event' => Event,
        'event_webhook' => EventWebhook,
        'gateway' => Gateway,
        'gateway_module' => GatewayModule,
        'invoice' => Invoice,
        'payment_session' => PaymentSession,
        'subscription' => Subscription,
        'submission_form' => SubmissionForm,
        'webhook' => Webhook,
        'list' => ListObject
      }
    end

    def self.convert_to_peakium_object(resp, api_key)
      case resp
      when Array
        resp.map { |i| convert_to_peakium_object(i, api_key) }
      when Hash
        # Try converting to a known object class.  If none available, fall back to generic PeakiumObject
        object_classes.fetch(resp[:object], PeakiumObject).construct_from(resp, api_key)
      else
        resp
      end
    end

    def self.file_readable(file)
      # This is nominally equivalent to File.readable?, but that can
      # report incorrect results on some more oddball filesystems
      # (such as AFS)
      begin
        File.open(file) { |f| }
      rescue
        false
      else
        true
      end
    end

    def self.symbolize_names(object)
      case object
      when Hash
        new = {}
        object.each do |key, value|
          key = (key.to_sym rescue key) || key
          new[key] = symbolize_names(value)
        end
        new
      when Array
        object.map { |value| symbolize_names(value) }
      else
        object
      end
    end

    def self.url_encode(key)
      URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    end

    def self.flatten_params(params, parent_key=nil)
      result = []
      params.each do |key, value|
        calculated_key = parent_key ? "#{parent_key}[#{url_encode(key)}]" : url_encode(key)
        if value.is_a?(Hash)
          result += flatten_params(value, calculated_key)
        elsif value.is_a?(Array)
          result += flatten_params_array(value, calculated_key)
        else
          result << [calculated_key, value]
        end
      end
      result
    end

    def self.flatten_params_array(value, calculated_key)
      result = []
      value.each_with_index do |elem,index|
        if elem.is_a?(Hash)
          result += flatten_params(elem, calculated_key + "[#{index}]")
        elsif elem.is_a?(Array)
          result += flatten_params_array(elem, calculated_key + "[#{index}]")
        else
          result << ["#{calculated_key}[#{index}]", elem]
        end
      end
      result
    end

    def self.camel_to_snake_case(camel)
      camel.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end
  end
end
