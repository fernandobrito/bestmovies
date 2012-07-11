require "dm-core"
require "dm-sqlite-adapter"
require "dm-validations"
require "dm-ar-finders"

DataMapper.setup(:default, "sqlite3://#{File.dirname(__FILE__)}/database.db")

class Event
  include DataMapper::Resource

  property :id,          Serial

  belongs_to :channel
  belongs_to :movie

  property :begins,      DateTime
  property :ends,        DateTime

  property :hagah_id,    String, :unique => true
end

class Movie
  include DataMapper::Resource

  property :id,          Serial

  property :title,        String, :length => 100
  property :original_title,  String, :length => 100

  property :score,       Float

  belongs_to :gender

  property :director,    String
  property :cast,        Text

  property :country,     String
  property :year,        Integer
  property :lenght,      Integer
  property :color,       String

  property :rating,      Text
  property :description, Text

  property :hagah_id,    String, :unique => true
  property :imdb_id,     String , :unique => true

  has n, :events
end

class Gender
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String , :unique => true

  has n, :movies
end

class Channel
  include DataMapper::Resource

  property :id,         Serial
  property :name,       String, :unique => true

  has n, :events
  has n, :movies, :through => :events
end

DataMapper.finalize

