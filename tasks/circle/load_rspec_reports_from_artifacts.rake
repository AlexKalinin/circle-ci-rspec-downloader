namespace 'circleci' do

  desc 'Download rspec reports'
  task :download_rspec_reports do
    puts 'Downloading rspec reports...'

    ci_params   = App.config['circle_ci']
    token       = ci_params['token']
    vcs_type    = ci_params['vcs_type']
    user_name   = ci_params['user_name']
    project     = ci_params['project']
    first_build = ci_params['first_build'].to_i
    last_build  = ci_params['last_build'].to_i

    ci = CircleCiApi.new token, vcs_type, user_name, project
    (first_build..last_build).each do |build_number|
      msg_uid = App.logger.uuid
      App.logger.info "Processing build #{build_number}...", msg_uid

      artifacts = ci.get_artifacts_info build_number
      if artifacts.is_a? Array
        artifacts.each do |artifact|
          if artifact['path'].include? 'rspec.xml'
            save_path = File.join(App.root, "artifacts/#{build_number}.xml")
            App.logger.debug "Saving file to #{save_path}...", msg_uid
            NetworkHelper.download(artifact['url'] + "?circle-token=#{token}", save_path)
          end
        end
      end
    end
  end
end
