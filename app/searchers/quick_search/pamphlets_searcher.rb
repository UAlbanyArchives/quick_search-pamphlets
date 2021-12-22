module QuickSearch
  class PamphletsSearcher < QuickSearch::Searcher
    
    def search
      @http.ssl_config.verify_mode=(OpenSSL::SSL::VERIFY_NONE)
      resp = @http.get(base_url, parameters.to_query)
      @response = JSON.parse(resp.body)
   end

    def results
      if results_list
        results_list

      else
        @results_list = []

        #@match_fields = ['title_ssm', '']
        @response['data'].each do |value|
          result = OpenStruct.new
          #result.title = value['title']['attributes']['value']
          result.title = value['attributes']['title_tesim']['attributes']['value']
          if value['attributes'].key?('display_date_tesim')
            result.date = value['attributes']['display_date_tesim']['attributes']['value'].gsub(/[^0-9a-z .-]/i, '')
          end
          if value['attributes'].key?('author_ssim')
            result.author = value['attributes']['author_ssim']['attributes']['value']
          end
          if value['attributes'].key?('illustrator_ssim')
            result.illustrator = value['attributes']['illustrator_ssim']['attributes']['value']
          end
          if value['attributes'].key?('translator_ssim')
            result.translator = value['attributes']['translator_ssim']['attributes']['value']
          end
          if value['attributes'].key?('contributor_ssim')
            result.contributor = value['attributes']['contributor_ssim']['attributes']['value']
          end
          result.link = value['links']['self']
          #if value.key?('description')
            #result.author = value['description'][0]
          #end
          if value['attributes'].key?('file')
            result.thumbnail = URI::join(value['attributes']['file']['attributes']['value'], "?file=thumbnail").to_s
          end
          #if value.key?('collection_tesim')
            #result.collection = [value['collection_tesim'][0], collection_builder(value['collection_number_tesim'][0]).to_s]
          #end
          #result.description = value['attributes']['description']['attributes']['value']

          @results_list << result
        end

        @results_list
      end

    end

    def base_url
      "https://archives.albany.edu/books/catalog"
    end

    def parameters
      {
        'f' => { 'collecting_area_ssim' => ['Political Pamphlets'] },
        'search_field' => 'all_fields',
        'q' => http_request_queries['not_escaped'],
        'utf8' => true,
        'per_page' => @per_page,
        'format' => 'json'
      }
    end

    #def link_builder(value)
    #  link = URI::join(base_url, +"/concern/" + value['has_model_ssim'][0].downcase + "s/" + value['id']).to_s
    #
    #  link
    #end

    def collection_builder(uri)
      collection_link = URI::join(base_url, +"/books/catalog/" + uri.tr(".", "-"))

      collection_link
    end

    def total
      @response['meta']['pages']['total_count'].to_i
    end

    def loaded_link
      "https://archives.albany.edu/books?f[collecting_area_ssim][]=Political+Pamphlets&search_field=all_fields&q=" + http_request_queries['not_escaped']
    end

  end
end

