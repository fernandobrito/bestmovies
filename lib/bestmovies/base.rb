#encoding: utf-8

module BestMovies
  module Base
    def self.save_channel(channel_group, date = Date.today)
      # start mechanize
      agent = Mechanize.new

      # read the argument and find which movies do we want
      case channel_group
      when "HBO"
        channels = URL_HBO
      when "Telecine"
        channels = URL_TELECINE
      when "HD"
        channels = URL_HD
      when "Others"
        channels = URL_OTHERS
      when "All"
        channels = URL_HBO.merge(URL_TELECINE).merge(URL_HD).merge(URL_OTHERS)
      else
        raise "Channel group #{channel_group} doesn't exist. Please Try: HBO, Telecine, HD, Others or All"
      end

      channels.each do |channel_name, channel_url|

        # goes to the channels page

        page = nil
        try 5 do
          page = agent.get(channel_url + "&data=#{date.strftime('%d/%m/%Y')}")
        end

        # find the object in the database
        channel_object = Channel.first_or_create(:name => channel_name)

        # LOG
        puts "\n"
        puts "*" * 50
        puts "---- Channel: #{channel_name} - Date: #{date.strftime('%d/%m/%Y')}"

        # iterate over all movies and goes to its page
        for link in page.parser.css("tr.filme a")

          # skips this iteraction if the link doesn't point to a program
          # had to write this after finding a description of a filme with a linked image inside
          next if !link["href"].include?("1&action=programa&programa=")

          # get the movie and the event id from the URL
          movie_hagah_id = link["href"].split("&").find { |a| a.include?("programa=") }.split("=").last
          event_hagah_id = link["href"].split("&").find { |a| a.include?("evento=") }.split("=").last

          # look if the event was already added
          if !Event.find_by_hagah_id(event_hagah_id).nil?
            puts "-- Event #{event_hagah_id} already added"
            next
          end

          # tries to find the movie in our database
          movie = Movie.find_by_hagah_id(movie_hagah_id)

          # get the information from the website
          # since we have to create the event, we need to get the begins and ends time
          info = BestMovies::Scrap.movie_from_url(URL_BASE + link["href"])

          # if there is no movie, creates it
          if movie
            puts "\n-- Movie #{movie.title} found in our database."
          else
            movie = info[:movie]

            # usually erotic movies have not enough informations and no record on imdb
            if info[:gender] == "Erótico"
              puts "--- Skipping erotic movie"
              next
            end

            movie.gender = Gender.first_or_create(:name => info[:gender])
            movie.score = BestMovies::Scrap.rating_from_imdb(movie).to_f
            movie.hagah_id = movie_hagah_id

            if !movie.save
              puts movie.errors.inspect
            end
          end

          # creates the event
          event = Event.create(:channel => channel_object, :movie => movie, :begins => info[:begins], :ends => info[:ends], :hagah_id => event_hagah_id)

          if !event.saved?
            puts event.errors.inspect
          end

        end
      end

    end
  end
end

