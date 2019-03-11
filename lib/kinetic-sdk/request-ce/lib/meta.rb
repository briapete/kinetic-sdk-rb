module KineticSdk
  class RequestCe

    # Retrieve Request CE application version
    #
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def app_version(headers=default_headers)
      info("Retrieving Request CE application version.")
      get("#{@api_url}/version", {}, headers)
    end

  end
end
