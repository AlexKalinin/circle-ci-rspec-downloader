namespace :report do
  desc 'Show random failing specs'
  task :random_failing_specs do
    # when we have a lot of failed tests, it means this is not randoms,
    # but possible CI error, for example not started some of service, like Solr or Postgres
    MAX_RANDOMS_PER_BUILD = 10
    random_specs = []
    hash_of_random_build = []

    multiple_hashes = Build.select('COUNT(vcs_revision) AS num, vcs_revision')
         .group(:vcs_revision).order('num DESC').having('num > 1')
    puts 'Searching builds with randoms: '
    multiple_hashes.each do |hash|
      print '.'
      success_builds_count = Build.where('vcs_revision = ? AND total_failures = ?', hash.vcs_revision, 0).count
      failed_builds_count  = Build.where('vcs_revision = ? AND total_failures > ?', hash.vcs_revision, 0).count
      if failed_builds_count != 0 && success_builds_count != 0
        hash_of_random_build << hash.vcs_revision
      end
    end
    puts 'Searching randoms in filtered builds: '
    hash_of_random_build.each do |hash|
      print ','
      Build.where(vcs_revision: hash).find_each do |build|
        print '-'
        failed_specs = build.specs.where(failed: true)
        next if failed_specs.count > MAX_RANDOMS_PER_BUILD
        failed_specs.find_each do |random_spec|
          print '+'
          random_specs << random_spec
        end
      end
    end

    # File.open(report_name, 'w') {|f| f.write(random_specs.group_by(&:name).to_json.to_s)}
    # File.open(report_name, 'w') {|f| f.write(random_specs.group_by(&:name).sort_by{|k, v| v.count}.reverse.to_json.to_s)}
    # puts "Writed to file: #{report_name}"
    report = {}
    random_specs.group_by(&:name).sort_by{|k, v| v.count}.reverse.each do |spec|
      report.merge!(
          spec.first => spec.second.sort_by{|s| s.build.number}.reverse
                            .map { |s| "https://circleci.com/gh/hcm4all/hcm4all/#{s.build.number}" }
      )
    end

    report_name = File.join(App.root,'reports/random_specs2.json')
    File.open(report_name, 'w') { |f| f.write(report.to_json.to_s) }
  end
end