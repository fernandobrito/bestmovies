$TESTING=true
$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require "mechanize"
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib bestmovies]))

