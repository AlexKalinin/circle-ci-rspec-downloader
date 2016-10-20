class NetworkHelper
  class << self
    def download(url, file_name)
      File.open(file_name, 'wb') do |saved_file|
        open(url, "rb") do |read_file|
          saved_file.write(read_file.read)
        end
      end
    end
  end
end