# encoding: utf-8

module BestMovies::Scrap
  def self.movie_from_url(url)
    # start Mechanize
    agent = Mechanize.new

    page = nil

    try 5 do
      page = agent.get(url)
    end

    movie = Movie.new

    movie.title = page.parser.css("h1.programa").text.fix_spaces

    ##### Manipulate strings #####
    date = page.parser.xpath('//ul[1]/li[1]/text()').to_s.strip
    begins = date + " " + page.parser.xpath('//ul[1]/li[2]/text()').to_s.strip
    ends = date + " " + page.parser.xpath('//ul[1]/li[3]/text()').to_s.strip

    begins = parse_portuguese_date(begins)
    ends = parse_portuguese_date(ends)
    gender = ""
    ##### Manipulate strings #####

    page.parser.xpath("//ul[@class='detalhes']/li").each do |line|
      line = line.text

      # there must be a better way to do this with REGEX, but I suck with it
      movie.original_title = line.split(":")[1..-1].join(":").strip if line.include?("Nome Original:")

      gender = line.split("/").last.strip if line.include?("Filme")

      movie.director = line.split(":").last.strip if line.include?("Direção:")
      movie.cast = line.split(":").last.strip  if line.include?("Elenco:")
      movie.country = line.split(":").last.strip if line.include?("País:")

      if line.include?("Ano:")
        movie.year = line.split(":").last.strip

        # avoids 99 as years
        movie.year = "19" + movie.year if movie.year.size == 2
      end

      movie.lenght = line.split(":").last.strip.to_i if line.include?("Duração:")
      movie.color = line.split(":").last.strip if line.include?("Cor:")
      movie.rating = line.split(":").last.strip if line.include?("Classificação:")

    end

    movie.description = page.parser.xpath('//p[1]/text()').to_s

    { :movie => movie, :begins => begins, :ends => ends, :gender => gender }
  end


  def self.rating_from_imdb(movie)
    imdb = ImdbParty::Imdb.new(:anonymize => true)

    search_query = movie.original_title || movie.title

    results = nil
    try 5 do
      results = imdb.find_by_title(search_query.fix_to_query).find_all {|movie| movie[:imdb_id] != nil}
    end

    puts "\n---- Searching for: #{search_query} (#{movie.year})"

    # first iteraction: try to find movies with the same title and the same year
    for result in results[0...5]

      # log
      puts "-- Result: #{result[:title]} (#{result[:year]})"

      # if the titles and the years are the same
      if result[:title] and result[:title].downcase == search_query.downcase and result[:year].to_s == movie.year.to_s

        imdb_movie = nil
        try 5 do
          imdb_movie = imdb.find_movie_by_id(result[:imdb_id])
        end

        #log
        puts "===> 1. Title and year match! Score: " + imdb_movie.rating.to_s

        return imdb_movie.rating.to_s
      end
    end

    if movie.director
      # log
      puts "--- Result was not found. Going to try the 2nd method (director: #{movie.director.split(",").first})"

      # second iteraction: go into every movie page and checks the director
      for result in results[0...7]

        imdb_movie = nil
        try 5 do
          imdb_movie = imdb.find_movie_by_id(result[:imdb_id])
        end

        # log
        puts "-- Result: #{imdb_movie.directors.map(&:name).to_s}"

        if movie.director and imdb_movie.directors.map(&:name).include? movie.director.split(",").first

          # log
          puts "===> 2. Director match! Score: " + imdb_movie.rating.to_s

          return imdb_movie.rating.to_s
        end
      end
    end

    # log
    puts "--- Result was not found. Going to try the 3rd method"

    # third iteraction: just like the second one, but now searching with the portuguese title
    if !movie.original_title.nil?  # if original_title is nil, the 2nd iteraction was made with the portuguese title already
      results = imdb.find_by_title(movie.title.fix_to_query).find_all {|movie| movie[:imdb_id] != nil}

      for result in results[0...7]

        try 5 do
          imdb_movie = imdb.find_movie_by_id(result[:imdb_id])
        end

        puts "-- Result: #{imdb_movie.directors.map(&:name).to_s}"

        if movie.director and imdb_movie.directors.map(&:name).include? movie.director.split(",").first

          # log
          puts "===> 3. Director match, searching with portuguese title! Score: " + imdb_movie.rating.to_s

          return imdb_movie.rating.to_s
        end
      end
    end

    puts "!!!!! Movie #{movie.title} was not found :("
  end
end

