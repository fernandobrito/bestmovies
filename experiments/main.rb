require "rubygems"
require "bundler/setup"
require "imdb_party"
require "debugger"

require File.join(File.dirname(__FILE__), '..', 'db', 'config')

LIMIT = 50

movie_ids = repository(:default).adapter.select("SELECT DISTINCT movie_id FROM events WHERE begins > '2014-03-20' LIMIT #{LIMIT}")

tp, tn, fp, fn = 0
imdb = ImdbParty::Imdb.new(:anonymize => true)

def register_movie(movie)
  return if movie.imdb_id

  imdb = ImdbParty::Imdb.new(:anonymize => true)
 
  puts "#" * 30
  puts "# Movie has no imdb_id"
  puts "#{movie.original_title} (#{movie.year}) (#{movie.director}) (#{movie.title})"

  result = imdb.find_by_title(movie.original_title || movie.title).first
  result = imdb.find_movie_by_id(result[:imdb_id])

  puts result.title + " (#{result.release_date}) (#{result.directors.map(&:name)})"
  puts "Accept? y/n"

  input = gets.chomp

  if input == 'y'
    movie.imdb_id = result.imdb_id
    # movie.save
  end

end

def naive_solution(movie)

end

def movie_matcher(movie)

end

for movie_id in movie_ids
  movie = Movie.find(movie_id)

  register_movie(movie)

  naive_solution(movie)
  movie_matcher(movie)

  #puts movie.imdb_id
  #puts imdb.find_by_title(movie.original_title)

  # debugger

  sleep 1
end

