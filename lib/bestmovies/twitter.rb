# encoding: utf-8

module BestMovies::Twitter
  def self.update_with_best_movies_between(size=2, channel_group, rating, begins, ends, time, update_twitter)
    twitter = BestMovies::Twitter.auth if update_twitter == "true"

    case channel_group
    when "HBO"
      channels = URL_HBO.keys
    when "Telecine"
      channels = URL_TELECINE.keys
    when "HD"
      channels = URL_HD.keys
    when "Others"
      channels = URL_OTHERS.keys
    when "All"
      channels = URL_HBO.merge(URL_TELECINE).merge(URL_HD).merge(URL_OTHERS).keys
    else
      raise "Channel group #{channel_group} doesn't exist. Please Try: HBO, Telecine, HD and Others"
    end

    events = Event.all(:begins.gte => begins, :begins.lte => ends, Event.channel.name => channels)
    # I couldn't do this using DataMapper, so its done with Ruby -.-
    events = events.sort_by { |event| event.movie.score }.reverse[0...size]
    events = events.delete_if { |event| event.movie.score <= rating }

    puts "-- Begins: #{begins.strftime('%d/%m/%Y %H:%M')}"
    puts "-- Ends: #{ends.strftime('%d/%m/%Y %H:%M')}\n"

    events.each_with_index do |event, index|

			if event.movie.title.include?("HDTV -")
				event.movie.title.gsub!("HDTV - ", "")
			end

			# The message to be tweeted. By default it has the movie title (pt-BR) and the original movie title
      output = "[ #{time} ] #{(event.begins).strftime('%H:%M')} .:. #{event.channel.name} .:. #{event.movie.title} (#{event.movie.original_title}) .:. Nota: #{event.movie.score} .:. Ano: #{event.movie.year} .:. Gênero: #{event.movie.gender.name}"

      # If there is no original title, or its the same as the normal title or the message is too big, remove the original_title
      if event.movie.original_title.nil? or event.movie.original_title == event.movie.title or output.size > 140
        output = "[ #{time} ] #{(event.begins).strftime('%H:%M')} .:. #{event.channel.name} .:. #{event.movie.title} .:. Nota: #{event.movie.score} .:. Ano: #{event.movie.year} .:. Gênero: #{event.movie.gender.name}"
			end

      # If it still too long, we have to remove the last chars of the movie title
      if output.size > 140
        max_title_size = -(output.size - event.movie.title.size - 137)
        output = "[ #{time} ] #{(event.begins).strftime('%H:%M')} .:. #{event.channel.name} .:. #{event.movie.title[0...max_title_size]}... .:. Nota: #{event.movie.score} .:. Ano: #{event.movie.year} .:. Gênero: #{event.movie.gender.name}"
      end

      puts "#{index+1}: #{output}"

      if update_twitter == "true"
      	twitter.update(output)
      	puts ":: Twitter updated!"
      end
    end
  end

  protected

  def self.auth
    config = ConfigStore.new(File.join(File.dirname(__FILE__), '..', '..', '.twitter'))
    oauth = Twitter::OAuth.new(config['token'], config['secret'])

    if config['atoken'] && config['asecret']
      oauth.authorize_from_access(config['atoken'], config['asecret'])
      twitter = Twitter::Base.new(oauth)

      return twitter

    elsif config['rtoken'] && config['rsecret']
      oauth.authorize_from_request(config['rtoken'], config['rsecret'])
      twitter = Twitter::Base.new(oauth)

      config.update({
        'atoken'  => oauth.access_token.token,
        'asecret' => oauth.access_token.secret,
      }).delete('rtoken', 'rsecret')

      return twitter

    else
      config.update({
        'rtoken'  => oauth.request_token.token,
        'rsecret' => oauth.request_token.secret,
      })

      # authorize in browser
      %x(google-chrome #{oauth.request_token.authorize_url})

      raise "voce precisa configurar o arquivo .twitter"
    end
  end
end
