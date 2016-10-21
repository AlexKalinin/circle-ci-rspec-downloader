namespace :db do
  desc 'Load rspec xml reports from artifacts folder'
  task :load_rspec_reports_from_artifacts do
    App.logger.info 'Loading rspec xml reports from artifacts...'

    Dir.foreach(File.join(App.root, 'artifacts/')) do |fname|
      next if %w(. ..).include? fname

      log_salt = App.logger.uuid
      fname_full = File.join(App.root, 'artifacts/', fname)
      build_number = File.basename(fname, File.extname(fname))
      App.logger.info "Processing file #{fname_full}...", log_salt

      xml = Nokogiri::XML(File.open(fname_full))
      Build.create_from_rspec xml, build_number, log_salt
    end
  end
end