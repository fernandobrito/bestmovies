#encoding: utf-8

require "rubygems"
require "bundler/setup"
require "twitter"
require "mechanize"
require "imdb_party"

require "time"
require "date"

require File.join(File.dirname(__FILE__), '..', 'db', 'config')
require File.join(File.dirname(__FILE__), 'helpers', 'config_store')
require File.join(File.dirname(__FILE__), 'helpers', 'urls')
require File.join(File.dirname(__FILE__), 'helpers', 'string_helpers')
require File.join(File.dirname(__FILE__), 'helpers', 'try_rescue')

module BestMovies
  VERSION = "0.0.1"
end

require File.join(File.dirname(__FILE__), 'bestmovies', 'base')
require File.join(File.dirname(__FILE__), 'bestmovies', 'scrap')
require File.join(File.dirname(__FILE__), 'bestmovies', 'twitter')

