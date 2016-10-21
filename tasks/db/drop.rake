namespace :db do
  desc 'Drop database'
  task :drop do
    db_file = File.join(App.root, 'db/application.db')
    File.delete db_file if File.exist? db_file
  end
end