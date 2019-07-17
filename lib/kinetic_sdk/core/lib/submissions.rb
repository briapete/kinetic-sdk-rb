module KineticSdk
  class Core

    # Add a Submission
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be added
    #   - +parent+ - Parent ID of the submission to be added
    #   - +values+ - hash of field values for the submission
    # @param parameters [Hash] hash of query parameters to append to the URL
    #   - +include+ - comma-separated list of properties to include in the response
    #   - +completed+ - signals that the submission should be completed, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_submission(kapp_slug, form_slug, payload={}, parameters={}, headers=default_headers)
      # initialize "values" if nil
      payload["values"] = {} if payload["values"].nil?
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # build the uri with the encoded parameters
      uri = URI.parse("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions")
      uri.query = URI.encode_www_form(parameters) unless parameters.empty?
      # Create the submission
      @logger.info("Adding a submission in the \"#{form_slug}\" Form.")
      post(uri.to_s, payload, headers)
    end

    # Add a Submission page
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param page_name [String] name of the Page
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be added
    #   - +parent+ - Parent ID of the submission to be added
    #   - +values+ - hash of field values for the submission
    # @param parameters [Hash] hash of query parameters to append to the URL
    #   - +include+ - comma-separated list of properties to include in the response
    #   - +staged+ - Indicates whether field validations and page advancement should occur, default is false
    #   - +defer+ - Indicates the submission is for a subform embedded in a parent, default is false
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def add_submission_page(kapp_slug, form_slug, page_name, payload={}, parameters={}, headers=default_headers)
      # initialize "values" if nil
      payload["values"] = {} if payload["values"].nil?
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # add the page name to the parameters
      parameters["page"] = page_name
      # build the uri with the encoded parameters
      uri = URI.parse("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions")
      uri.query = URI.encode_www_form(parameters)
      # Create the submission
      @logger.info("Adding a submission page in the \"#{form_slug}\" Form.")
      post(uri.to_s, payload, headers)
    end

    # Patch a new Submission
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be patched
    #   - +parent+ - Parent ID of the submission to be patched
    #   - +values+ - hash of field values for the submission
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def patch_new_submission(kapp_slug, form_slug, payload={}, headers=default_headers)
      # set the currentPage hash if currentPage was passed as a string
      payload["currentPage"] = { "name" => payload["currentPage"] } if payload["currentPage"].is_a? String
      # initialize "values" if nil
      payload["values"] = {} if payload["values"].nil?
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # Create the submission
      @logger.info("Patching a submission in the \"#{form_slug}\" Form.")
      patch("#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions", payload, headers)
    end

    # Patch an existing Submission
    #
    # @param submission_id [String] id of the Submission
    # @param payload [Hash] payload of the submission
    #   - +origin+ - Origin ID of the submission to be patched
    #   - +parent+ - Parent ID of the submission to be patched
    #   - +values+ - hash of field values for the submission
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def patch_existing_submission(submission_id, payload={}, headers=default_headers)
      # set the currentPage hash if currentPage was passed as a string
      payload["currentPage"] = { "name" => payload["currentPage"] } if payload["currentPage"].is_a? String
      # initialize "values" if nil
      payload["values"] = {} if payload["values"].nil?
      # set origin hash if origin was passed as a string
      payload["origin"] = { "id" => payload["origin"] } if payload["origin"].is_a? String
      # set parent hash if parent was passed as a string
      payload["parent"] = { "id" => payload["parent"] } if payload["parent"].is_a? String
      # Create the submission
      @logger.info("Patching a submission with id \"#{submission_id}\"")
      patch("#{@api_url}/submissions/#{submission_id}", payload, headers)
    end

    # Find all Submissions for a form.
    #
    # This method will process pages of form submissions and internally
    # concatenate the results into a single array.
    #
    # Warning - using this method can cause out of memory errors on large
    #           result sets.
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_all_form_submissions(kapp_slug, form_slug, params={}, headers=default_headers)
      @logger.info("Finding submissions for the \"#{form_slug}\" Form.")
      # Make the initial request of pages submissions
      response = find_form_submissions(kapp_slug, form_slug, params, headers)
      # Build the Messages Array
      messages = response.content["messages"]
      # Build Submissions Array
      submissions = response.content["submissions"]
      # if a next page token exists, keep retrieving submissions and add them to the results
      while (!response.content["nextPageToken"].nil?)
        params['pageToken'] = response.content["nextPageToken"]
        response = find_form_submissions(kapp_slug, form_slug, params, headers)
        # concat the messages
        messages.concat(response.content["messages"] || [])
        # concat the submissions
        submissions.concat(response.content["submissions"] || [])
      end
      final_content = { "messages" => messages, "submissions" => submissions, "nextPageToken" => nil }
      # Return the results
      response.content=final_content
      response.content_string=final_content.to_json
      response
    end

    # Find a page of Submissions for a form.
    #
    # The page offset can be defined by passing in the "pageToken" parameter,
    # indicating the value of the token that will represent the first
    # submission in the result set.  If not provided, the first page of
    # submissions will be retrieved.
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param form_slug [String] slug of the Form
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    #   - +pageToken+ - used for paginated results
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_form_submissions(kapp_slug, form_slug, params={}, headers=default_headers)
      # Get next page token
      token = params["pageToken"]
      if token.nil?
        @logger.info("Finding first page of submissions for the \"#{form_slug}\" Form.")
      else
        @logger.info("Finding page of submissions starting with token \"#{token}\" for the \"#{form_slug}\" Form.")
      end

      # Build Submission URL
      url = "#{@api_url}/kapps/#{kapp_slug}/forms/#{form_slug}/submissions"
      # Return the response
      get(url, params, headers)
    end

    # Find a page of Submissions for a kapp.
    #
    # The page offset can be defined by passing in the "pageToken" parameter,
    # indicating the value of the token that will represent the first
    # submission in the result set.  If not provided, the first page of
    # submissions will be retrieved.
    #
    # @param kapp_slug [String] slug of the Kapp
    # @param params [Hash] Query parameters that are added to the URL, such as +include+
    #   - +pageToken+ - used for paginated results
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def find_kapp_submissions(kapp_slug, params={}, headers=default_headers)
      # Get next page token
      token = params["pageToken"]
      if token.nil?
        @logger.info("Finding first page of submissions for the \"#{kapp_slug}\" Kapp.")
      else
        @logger.info("Finding page of submissions starting with token \"#{token}\" for the \"#{kapp_slug}\" Kapp.")
      end

      # Build Submission URL
      url = "#{@api_url}/kapps/#{kapp_slug}/submissions"
      # Return the response
      get(url, params, headers)
    end

    # Update a submission
    #
    # @param submission_id [String] String value of the Submission Id (UUID)
    # @param body [Hash] submission properties to update
    # @param headers [Hash] hash of headers to send, default is basic authentication and accept JSON content type
    # @return [KineticSdk::Utils::KineticHttpResponse] object, with +code+, +message+, +content_string+, and +content+ properties
    def update_submission(submission_id, body={}, headers=default_headers)
      @logger.info("Updating Submission \"#{submission_id}\"")
      put("#{@api_url}/submissions/#{encode(submission_id)}", body, headers)
    end

  end
end
