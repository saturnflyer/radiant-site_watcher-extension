module PopularPageTags
  include Radiant::Taggable
  
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
    Popular pages are limited to a total of 25. This tag will set the current
    page to the current popular page from the loop, so you may use whatever
    standard tags exist such as @<r:title />@ or @<r:link />@ for example.
  }
  tag 'popular:pages:each' do |tag|
    results = []
    tag.locals.popular_pages = Page.find_popular
    tag.locals.popular_pages.each do |page|
      tag.locals.page = page
      results << tag.expand
    end
    results
  end
end
