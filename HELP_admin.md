Site Watcher will create a 'page_requests' table that records each time
the cache is created for a particular page. It is not a way to track
every request to your site.

## Popular Pages

Site Watcher provides tags that may be used in radiant pages to display
the most popular pages. Because this information is stored in the 
database, Site Watcher only stores the number of times the cache is 
created, not the number of times the page has been requested.

The Site Watcher Radius tags aim to provide an overview of popular pages
without the need to have Radiant connect to an external service for
tracking page popularity.

## Viewing Popular Pages

Site Watcher will use Dashboard (if you have it installed) so that you 
can see your popular pages from the admin interface. See
http://ext.radiantcms.org/extensions/40-dashboard for more details.

## Real Request Tracking

You would be well advised to keep track of page requests via something 
like your webserver log files if you would like to keep track of every
request that your site serves.