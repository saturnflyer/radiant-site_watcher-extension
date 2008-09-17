module PopularPageTags
  include Radiant::Taggable
  
  class TagError < StandardError; end
  
  desc %{
    Sets the scope for popular items
  }
  tag 'popular' do |tag|
    tag.expand
  end
  
  desc %{
    Sets the scope for popular pages
  }
  tag 'popular:pages' do |tag|
    tag.expand
  end
  
  desc %{
    Loops through the popular pages and outputs it's contents for each one.
    Popular pages are limited to a total of 25 or by the number given in the
    @limit@ attribute. 
    
    This tag will set the current page to the current popular page from the 
    loop, so you may use whatever standard tags exist such as @<r:title />@
    or @<r:link />@ for example.
    
    *Usage:*
    <pre><code><r:popular:pages:each [limit='3']>...</r:popular:pages:each></code><pre>
  }
  tag 'popular:pages:each' do |tag|
    limit = tag.attr['limit'] || '25'
    if limit.match(/^\d{1,4}$/)
      limit = limit.to_i
    else
      raise TagError.new("`limit' attribute of `each' tag must be a positive number between 1 and 4 digits")
    end
    results = []
    tag.locals.popular_pages = Page.find_popular(limit)
    tag.locals.popular_pages.each do |page|
      tag.locals.page = page
      results << tag.expand
    end
    results
  end
end
