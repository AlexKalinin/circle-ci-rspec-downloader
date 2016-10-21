class Build < ActiveRecord::Base
  has_many :specs

  def self.create_from_rspec(xml, number, log_salt = nil)
    build_options = {number: number}
    { tests: :total_tests, failures: :total_failures,
      errors: :total_errors, time: :total_time, timestamp: :build_date }.each do |k, v|
      build_options.merge!({v => xml.at_xpath("//testsuite/@#{k}")&.value})
    end
    build = Build.create! build_options
    App.logger.debug "Parsed build: #{build.to_s}", log_salt

    xml.xpath('//testsuite/testcase').each do |xml_testcase|
      Spec.create_from_rspec xml_testcase, build, log_salt
    end
  end

  def to_s
    "[Build '#{self.number}']"
  end
end