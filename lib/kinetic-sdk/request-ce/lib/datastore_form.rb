module KineticSdk
  class RequestCe

    # Add a Datastore Form
    #
    # @param form_properties [Hash] form properties
    #   - +customHeadContent+
    #   - +description+
    #   - +name+
    #   - +notes+
    #   - +slug+
    #   - +status+
    #   - +submissionLabelExpression+
    #   - +attributes+
    #   - +attributesMap+
    #   - +bridgedResources+
    #   - +pages+
    #   - +securityPolicies+
    #   - +indexDefinitions+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_datastore_form(form_properties={}, headers=default_headers)
      info("Adding the \"#{form_properties['name']}\" Form.")
      post("#{@api_url}/datastore/forms", form_properties, headers)
    end

    # Delete a Datastore Form
    #
    # @param form_slug [String] slug of the form
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def delete_datastore_form(form_slug, headers=default_headers)
      info("Deleting the \"#{form_slug}\" Datastore Form")
      delete("#{@api_url}/datastore/forms/#{form_slug}", headers)
    end

    # Export a Datastore Form
    #
    # @param form_slug [String] slug of the form
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def export_datastore_form(form_slug, headers=default_headers)
      info("Exporting the \"#{form_slug}\" Datastore Form.")
      get("#{@api_url}/datastore/forms/#{form_slug}", { 'export' => true }, headers)
    end

    # Find Datastore Forms
    #
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_datastore_forms(params={}, headers=default_headers)
      info("Finding Forms.")
      get("#{@api_url}/datastore/forms", params, headers)
    end

    # Find a Datastore Form
    #
    # @param form_slug [String] slug of the form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_datastore_form(form_slug, params={}, headers=default_headers)
      info("Finding the \"#{form_slug}\" Datastore Form")
      get("#{@api_url}/datastore/forms/#{form_slug}", params, headers)
    end

    # Update a Datastore Form
    #
    # @param form_slug [String] slug of the form
    # @param properties [Hash] form properties to update
    #   - +customHeadContent+
    #   - +description+
    #   - +name+
    #   - +notes+
    #   - +slug+
    #   - +status+
    #   - +submissionLabelExpression+
    #   - +attributes+
    #   - +attributesMap+
    #   - +bridgedResources+
    #   - +pages+
    #   - +securityPolicies+
    #   - +indexDefinitions+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_datastore_form(form_slug, properties={}, headers=default_headers)
      info("Updating the \"#{form_slug}\" Datastore Form.")
      put("#{@api_url}/datastore/forms/#{form_slug}", properties, headers)
    end

    # Build Datastore Indexes
    # 
    # @param form_slug [String] slug of the form
    # @param indexes [Array] array of index names to build indexes
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def build_datastore_form_indexes(form_slug, indexes, headers=default_headers)
      payload = {
        "type" => "Datastore Indexing",
        "content" => {
          "indexes" => indexes
        }
      }
      info("Building indexes for the \"#{form_slug}\" Datastore Form.")
      post("#{@api_url}/datastore/forms/#{form_slug}/backgroundJobs", payload, headers)
    end

  end
end
