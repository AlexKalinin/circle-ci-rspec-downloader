namespace :db do
  desc 'Drop, Create, Migrate and Seed database'
  task :reset do
    %w(db:drop db:migrate).each do |task_name|
      puts "Executing #{task_name}..."
      Rake::Task[task_name].invoke
    end
  end
end