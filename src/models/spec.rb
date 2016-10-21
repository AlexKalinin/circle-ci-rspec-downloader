class Spec < ActiveRecord::Base
  belongs_to :build

  def self.create_from_rspec(xml, build, log_salt = nil)
    spec_options = {build: build}
    %w(classname name file time).each do |k|
      spec_options.merge!({ k => xml.attributes[k]&.value })
    end

    spec_options.merge!({
      failed: xml.at_xpath("self::testcase/failure")&.any?,
      failue_message: xml.at_xpath("self::testcase/failure/@message")&.value,
      failue_type: xml.at_xpath("self::testcase/failure/@type")&.value,
      failue_text: xml.at_xpath("self::testcase/failure")&.text
    })

    spec = Spec.create! spec_options
    App.logger.debug "Parsed testcase: #{spec.to_s}", log_salt
  end

  def to_s
    "[Spec '#{name}']"
  end
end