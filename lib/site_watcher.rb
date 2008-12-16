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
            @page_request.save unless @page_request.updated_at > Time.now - 5.minutes
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
        after_save :update_page_request_virtual
        
        def self.find_popular(num=25,author=nil)
          author = User.find(:first, :conditions => ['login = ?',author])
          page_requests = PageRequest.find(:all, :order => 'count_created DESC', :conditions => ['virtual = ?', false], :limit => num)
          pages = []
          page_requests.each do |req|
            the_page = Page.find_by_url(req.url)
            if author.nil?
              pages << the_page
            elsif the_page.created_by_id == author.id
              pages << the_page
            end
          end
          pages
        end
        def popularity
          count = PageRequest.find_by_url(url).count_created
          count_max = PageRequest.maximum('count_created')
          popularity = count/count_max.to_f
          result = sprintf("%.0f", popularity * 100)
        end     
        def update_page_request_virtual(reset_virtual=nil)
          if pr = PageRequest.find_by_url(url)
            new_value = reset_virtual ? reset_virtual : virtual
            pr.update_attribute(:virtual, new_value)
          end
        end
      }
    end
  end
end