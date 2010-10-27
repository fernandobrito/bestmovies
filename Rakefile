#encoding: utf-8

require 'rubygems'
require 'rake'
require 'rspec/core/rake_task'
require 'irb'

# Require my lib
require File.expand_path(File.join(File.dirname(__FILE__), %w[lib bestmovies]))

# Make the default task "testing"
task :default => :spec

# Run all tests
desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
  t.pattern = 'spec/**/*_spec.rb'
end


# Include other tasks
Dir['tasks/*.rake'].each { |t| load t }

desc "Open the console with the library loaded"
task :console do
  ARGV.clear
  IRB.start
end



desc "Find movies from today without score"
task :fix_movies do
  begins = Time.parse(Time.now.strftime("%d/%m/%Y") + " 00:00")
  ends = Date.today + 3

  events = Event.all(:begins.gte => begins, :begins.lte => ends, Event.movie.score => 0, Event.movie.gender.name.not => "Erótico").sort_by { |event| event.movie.title }

  movies = []

  for event in events
    movies << event.movie
  end

  movies.uniq!.each_with_index do |movie, index|
    puts "#{index+1}: #{movie.id} - #{movie.title} - #{movie.original_title} - #{movie.year} - #{movie.director} - #{movie.gender.name} - #{movie.events.first.channel.name}"

    movie.score = $stdin.gets.chomp.to_f

    if !movie.score.nil? and !movie.score != 0.0
      puts "Saving score\n\n"
      movie.save
    end
  end
end

