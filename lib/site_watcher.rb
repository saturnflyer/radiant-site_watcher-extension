module SiteWatcher
  module PageTrack
      def self.included(base)
        base.class_eval { alias_method_chain :show_uncached_page, :page_track }
      end
      
      private 
      
      def show_uncached_page_with_page_track(url)
        @page = find_page(url)
        unless @page.nil?
          if @page_request = PageRequest.find_or_create_by_url(:url => format_url(url), :virtual => @page.virtual)
            @page_request.save if @page_request.count_created > 1
            process_page(@page)
            @cache.cache_response(url, response) if request.get? and live? and @page.cache?
            @performed_render = true
          else
            show_uncached_page_without_page_track
          end
        else
          render :template => 'site/not_found', :status => 404
        end
      rescue Page::MissingRootPageError
        redirect_to welcome_url
      end
      
      def format_url(url)
        unless url.match(/^\/\w*/)
          url = "/#{url}"
        else
          url
        end
      end
  end
  module PageExtension
    def self.included(base)
      base.class_eval {
        def self.find_popular(num=25)
          page_requests = PageRequest.find(:all, :order => 'count_created DESC', :conditions => ['virtual = ?', false], :limit => num)
          pages = []
          page_requests.each do |req|
            pages << Page.find_by_url(req.url)
          end
          pages
        end
        def popularity
          count = PageRequest.find_by_url(url).count_created
          count_max = PageRequest.maximum('count_created')
          popularity = count/count_max.to_f
          result = sprintf("%.0f", popularity * 100)
        end
      }
    end
  end
end