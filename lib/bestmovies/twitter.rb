# encoding: utf-8

module BestMovies::Twitter
  def self.update_with_best_movies_between(size=2, channel_group, begins, ends, time, update_twitter)
    twitter = BestMovies::Twitter.auth

    # Gambiarra horrível para o horário de verão
    begins = begins + (60*60)
    ends = ends + (60*60)

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
    events = events.sort_by { |event| event.movie.score }.reverse[0...size]

    puts "-- Begins: #{begins.strftime('%d/%m/%Y %H:%M')}"
    puts "-- Ends: #{ends.strftime('%d/%m/%Y %H:%M')}\n"

    events.each_with_index do |event, index|
      output = "[ #{time} ] #{(event.begins-60*60).strftime('%H:%M')} .:. #{event.channel.name} .:. #{event.movie.title} (#{event.movie.original_title}) .:. Nota: #{event.movie.score} .:. Ano: #{event.movie.year} .:. Gênero: #{event.movie.gender.name} .:. [GMT -3]"

      if event.movie.original_title.nil? or event.movie.original_title == event.movie.title or output.size > 140
        output = "[ #{time} ] #{(event.begins-60*60).strftime('%H:%M')} .:. #{event.channel.name} .:. #{event.movie.title} .:. Nota: #{event.movie.score} .:. Ano: #{event.movie.year} .:. Gênero: #{event.movie.gender.name} .:. [GMT -3]"
      end

      puts "#{index+1}: #{output}"

      if update_twitter == "true"
      	twitter.update(output)
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

