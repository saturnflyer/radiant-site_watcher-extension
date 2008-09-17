module SiteWatcher
  module PageTrack
      def self.included(base)
        base.class_eval { alias_method_chain :show_page, :page_track }
      end

      def show_page_with_page_track
        response.headers.delete('Cache-Control')
    
        url = params[:url]
        if Array === url
          url = url.join('/')
        else
          url = url.to_s
        end
    
        if (request.get? || request.head?) and live? and (@cache.response_cached?(url))
          show_page_without_page_track
        else
          page = Page.find_by_url(url)
          page_request = PageRequest.find_or_create_by_url(url)
          page_request[:virtual] = page.virtual
          page_request[:count_created] = page_request[:count_created] + 1
          page_request.save
          show_uncached_page(url)
        end
      end
  end
end