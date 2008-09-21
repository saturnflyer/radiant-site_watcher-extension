Site Watcher will create a `page_requests` table that records each time
the cache is created for a particular page. It is not a way to track
every request to your site.

## Popular Pages

Site Watcher provides tags that may be used in radiant pages to display
the most popular pages. Because this information is stored in the 
database, Site Watcher only stores the number of times the cache is 
created, not the number of times the page has been requested. 

This means that if a page cache has been created for a particular page 
that has no existing cache, that request will be recorded in the database. 
If that page has been requested multiple times between the time of that
original request and the expiration of the cache, none of those particular
requests will be recorded.

The Site Watcher Radius tags aim to provide an overview of popular pages
without the need to have Radiant connect to an external service for
tracking page popularity.

## Viewing Popular Pages

Site Watcher will use Dashboard (if you have it installed) so that you 
can see your popular pages from the admin interface. See 
[Dashboard](http://ext.radiantcms.org/extensions/40-dashboard) for more details.

This is different from your list of popular pages provided by the 
`<r:popular_pages>` tags. Popular Pages listed on the Dashboard will display
all page requests. So if you have many requests for a non-existant page, the
Dashboard information will show this, whereas the tags will only display
actual pages in your system.

### Page Score

Each requested page will receive a score between 1 and 100 with 100 being 
the most popular. If 2 pages have been requested the same number of times
and they are both the most popular, they will both have a score of 100.

The score is calculated by `(count of the particular page requests / highest page request value) * 100`

## Real Request Tracking

You would be well advised to keep track of page requests via something 
like your webserver log files if you would like to keep track of every
request that your site serves.