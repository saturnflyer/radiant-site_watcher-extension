namespace :radiant do
  namespace :extensions do
    namespace :site_watcher do
      
      desc "Runs the migration of the Site Watcher extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          SiteWatcherExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          SiteWatcherExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Site Watcher to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from SiteWatcherExtension"
        Dir[SiteWatcherExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(SiteWatcherExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
