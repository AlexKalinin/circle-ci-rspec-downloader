class CircleCiApi
  # CircleCI authentication token
  attr_writer :token

  # Project
  attr_writer :vcs_type
  attr_writer :user_name
  attr_writer :project

  def initialize(token, vcs_type, user_name, project)
    @token = token
    @vcs_type = vcs_type
    @user_name = user_name
    @project = project
  end

  def get_info_about_me
    execute_request('/me')
  end

  def get_build_info(number)
    execute_request("/project/#{@vcs_type}/#{@user_name}/#{@project}/#{number}")
  end

  def get_artifacts_info(build_number)
    execute_request("/project/#{@vcs_type}/#{@user_name}/#{@project}/#{build_number}/artifacts")
  end

  private

    def execute_request(request_method, params = nil)
      params ||= {}
      params.merge!({'circle-token' => @token})

      uri = URI.parse("https://circleci.com/api/v1.1#{request_method}")
      uri.query = URI.encode_www_form(params)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)

      if response.code == "200"
        JSON.parse(response.body)
      else
        { error: response.msg, code: response.code }
      end
    end
end