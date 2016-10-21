namespace :circleci do
  desc 'Load additional data for builds from CircleCI API'
  task :load_additional_data_for_builds do
    puts 'Loading additional data for builds from CircleCI API...'
    ci_params   = App.config['circle_ci']
    token       = ci_params['token']
    vcs_type    = ci_params['vcs_type']
    user_name   = ci_params['user_name']
    project     = ci_params['project']

    ci = CircleCiApi.new token, vcs_type, user_name, project
    Build.find_each do |build|
      data =  ci.get_build_info build.number
      build.update_attributes!({ compare_url: data['compare'],
                                 vcs_revision: data['vcs_revision'],
                                 json_data: data.to_s
                               })
      print " #{build.id},"
    end
    puts "\nFinished."
  end
end