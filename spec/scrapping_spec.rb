#encoding: utf-8

require File.dirname(__FILE__) + '/spec_helper'

info = BestMovies::Scrap.movie_from_url("http://www.hagah.com.br/programacao-tv/jsp/default.jsp?uf=1&action=programa&canal=MAX&operadora=14&programa=0000196311&evento=000000483066613")
movie = info[:movie]

describe "BestMovies Scrapping movie with all informations" do
  it "should scrap a movie's title" do
    movie.title.should == "O Curioso Caso de Benjamin Button"
  end

  it "should scrap a movie's original title" do
    movie.original_title.should == "The Curious Case of Benjamin Button"
  end

  it "should scrap when the movie begins" do
    info[:begins].strftime("%d/%m/%Y %H:%M").should == "27/10/2010 17:30"
  end

  it "should scrap when the movie ends" do
    info[:ends].strftime("%d/%m/%Y %H:%M").should == "27/10/2010 20:20"
  end

  it "should scrap the movie's gender" do
    info[:gender].should == "Drama"
  end

  it "should scrap the movie's director" do
    movie.director.should == "David Fincher"
  end

  it "should scrap the movie's cast" do
    movie.cast.should include "Brad Pitt, Julia Ormond, Faune A. Chambers"
  end

  it "should scrap the movie's country" do
    movie.country.should == "EUA"
  end

  it "should scrap the movie's year" do
    movie.year.should == 2008
  end

  it "should scrap the movie's lenght" do
    movie.lenght.should == 166
  end

  it "should scrap the movie's color" do
    movie.color.should == "Colorido"
  end

  it "should scrap the movie's parental rating" do
    movie.rating.should == "Programa permitido para menores acompanhados dos pais"
  end

  it "should scrap the movie's description" do
    movie.description.should include "Drama baseado no clássico romance homônimo escrito por F. Scott Fitzgerald nos anos de 1920"
  end
end

######################################################################################################################

=begin
I need to find another movie with missing informations


info2 = BestMovies::Scrap.movie_from_url("http://www.hagah.com.br/programacao-tv/jsp/default.jsp?uf=1&action=programa&programa=0000184787&evento=000000482962376&operadora=14&canal=HB2&gds=1")
movie2 = info2[:movie]

describe "BestMovies Scrapping movie with missing informations" do
  it "should scrap a movie's title" do
    movie2.title.should == "Os Falsários"
  end

  it "should scrap a movie's original title" do
    movie2.original_title.should == nil
  end

  it "should scrap when the movie begins" do
    info2[:begins].strftime("%d/%m/%Y %H:%M").should == "17/10/2010 16:10"
  end

  it "should scrap when the movie ends" do
    info2[:ends].strftime("%d/%m/%Y %H:%M").should == "17/10/2010 17:52"
  end

  it "should scrap the movie's gender" do
    info2[:gender].should == "Drama"
  end

  it "should scrap the movie's director" do
    movie2.director.should == nil
  end

  it "should scrap the movie's cast" do
    movie2.cast.should == nil
  end

  it "should scrap the movie's country" do
    movie2.country.should == nil
  end

  it "should scrap the movie's year" do
    movie2.year.should == 2006
  end

  it "should scrap the movie's lenght" do
    movie2.lenght.should == 95
  end

  it "should scrap the movie's color" do
    movie2.color.should == "Colorido"
  end

  it "should scrap the movie's parental rating" do
    movie2.rating.should == "Programa para jovens e adultos"
  end

  it "should scrap the movie's description" do
    movie2.description.should include "um famoso falsificador judeu, é preso pelos nazistas e levado a um campo de concentração."
  end
end

=end

