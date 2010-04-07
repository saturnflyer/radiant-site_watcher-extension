module SiteWatcher
  module PageTrack
      def self.included(base)
        base.class_eval { before_filter :page_track, :only => :show_page }
      end
      
      private 
      
      def page_track
        url = format_url(params[:url])
        @page = find_page(url)
        if @page.nil?
          record_not_found(url)
        else
          if @page_request = PageRequest.find_or_initialize_by_url(:url => format_url(url), :virtual => @page.virtual)
            @page_request.save
          end
          record_not_found(url) if @page.kind_of?(FileNotFoundPage)
        end
      end
      
      def record_not_found(url)
        @not_found_request = NotFoundRequest.find_or_initialize_by_url(:url => format_url(url))
        referrer = request.env['HTTP_REFERER']
        if @not_found_request.save && referrer.present?
          @bad_referrer = BadReferrer.find_or_initialize_by_url(:url => referrer)
          @bad_referrer.save! if @bad_referrer.new_record?
          bad_direction = BadDirection.first(:conditions => {:not_found_request_id => @not_found_request.id, :bad_referrer_id => @bad_referrer.id})
          if bad_direction
            bad_direction.touch
          else
            BadDirection.create!(:not_found_request => @not_found_request, :bad_referrer => @bad_referrer)
          end
        end
      end
      
      def format_url(url)
        if Array === url
          url = url.join('/')
        else
          url = url.to_s
        end
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