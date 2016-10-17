require 'nokogiri'
require 'pry'

$test_cases = []

$result = []

def add(name, time, file)
  puts "Adding #{time} to #{name}"
  $test_cases << { name: name, time: time, file: file }
end

Dir.foreach('./artefacts/') do |file_name|
  next if file_name == '.' or file_name == '..'

  puts "Processing file: #{file_name}..."

  xml = Nokogiri::XML(File.open("./artefacts/#{file_name}"))
  xml.xpath('//testsuite/testcase').each do |kase|
    add kase.attributes['name'].to_s, kase.attributes['time'].to_s.to_f, kase.attributes['file'].to_s
  end
end

$test_cases.group_by { |test| test[:name]}.each do |test|
  name = test[0]
  count = test[1].count

  total_time = 0
  test[1].each {|record| total_time += record[:time]}
  file = test[1].first[:file] if test[1].first

  $result << { name: name, time: total_time / count, count: count, file: file }
end

binding.pry
puts $result.sort{ |a, b| a[:time] > b[:time] ? -1 : 1 }