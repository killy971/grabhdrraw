#!/usr/bin/env ruby1.9

require 'fileutils'
require 'find'
require 'shellwords'
require 'trollop'

opts = Trollop::options do
  opt :input, "input directory", :short => 'i', :type => String
  opt :output, "output directory", :short => 'o', :type => String
end

input_directory = opts[:input]
output_directory = opts[:output]

if !File.exists?(output_directory)
  FileUtils.mkdir output_directory
elsif !File.directory?(output_directory)
  puts output_directory + " already exists but is not a directory"
  exit
end

puts "Using input directory: " + input_directory

photos = Hash.new

Find.find(input_directory) do |file|
  next if File.directory? file
  Find.prune if !File.extname(file).end_with? "RW2"
  exif = `exiftool #{file.shellescape}`
  exposure_compensation = exif.split("\n").select{|line|
    line.start_with? "Exposure Compensation"
  }.first.split(":")[1].strip.to_f
  photos[file] = exposure_compensation
  # puts file + " " + exposure_compensation
end

candidate = Hash.new

photos.each_pair do |file, exposure_compensation|
  file, exposure_compensation = photos.shift
  candidate[file] = exposure_compensation
  #puts candidate.values.join(", ")
  if candidate.values == [0.0, -0.66, 0.66, -1.33, 1.33]
    puts "HDR target found: " + candidate.keys.map{|path| File.basename(path)}.join(", ")
    candidate.keys.each do |file|
      unless File.exists?(output_directory + "//" + File.basename(file))
        FileUtils.cp file, output_directory
      end
    end
  end
  candidate.shift if candidate.size == 5
end
