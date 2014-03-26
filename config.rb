require 'rubygems'
require 'bundler/setup'

require 'erb'
require 'json'
require 'time'
require 'yaml'

Bundler.require(:default)

config_path = File.join('.', 'config.json').to_s

puts "Config file path: #{Rainbow(config_path).green}"
puts "Run UUID:         #{UUID.generate}"
puts

if File.exists?(config_path)
  puts Rainbow.new.wrap("== Starting up: #{Time.now.utc.xmlschema} ".ljust(80, '=')).blue
else
  puts Rainbow("Unable to stat config file #{config_path}").red
  puts Rainbow("Peacing out").red
  exit 1
end

raw_json = File.read(config_path)
puts "Read #{raw_json.length} bytes of JSON from #{config_path}"
config_file_entries = JSON.parse(raw_json)
puts "Parsed #{config_file_entries.length} config file entries"

puts Rainbow("== Processing: config files ".ljust(80, '=')).blue

config_file_entries.each do |hash|
  puts "-> Processing #{hash['title']}"
  input_filename = hash['input']
  output_filename = hash['output']
  if File.exists?(input_filename)
    cmd = "mkdir -p #{File.dirname(output_filename)}"
    puts cmd
    system cmd

    raw_config_file = File.read(input_filename)
    puts "Read #{raw_config_file.length} bytes from #{input_filename}"
    processed_config_file = ERB.new(raw_config_file, nil, '>').result(binding)
    puts "Output_Filename config file has #{processed_config_file.length} bytes"
    File.open(output_filename, 'w') {|f| f << processed_config_file }
    puts Rainbow("Completed ").green + "#{input_filename} -> #{output_filename}"
  else
    puts Rainbow("Couldn't stat file #{input_filename}! Skipping.").red
  end
end
puts "== Finished: #{Time.now.utc.xmlschema} ".ljust(80, '=')
puts
