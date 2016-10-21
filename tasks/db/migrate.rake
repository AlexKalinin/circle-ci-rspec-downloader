namespace :db do
  desc 'Migrate database'
  task :migrate do
    puts 'Migrating database...'
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate App.migrations_dir, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end
end