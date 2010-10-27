namespace :scrapping do

  task :default => :scrap

  desc "Scrap the movies"
  task :scrap do

    # Get params
    group = (ARGV.find { |arg| /^GROUP/ =~ arg }.split("=").last       if  ARGV.find { |arg| /^GROUP/ =~ arg })  || "All"
    days  = (ARGV.find { |arg| /^DAYS/ =~ arg }.split("=").last.to_i   if ARGV.find { |arg|  /^DAYS/ =~ arg })   || 2

    puts "-- Scrapping movies from group '#{group}' for the next '#{days}' day(s)"


    puts "\n\n--- Date: #{Date.today}"
    BestMovies::Base.save_channel(group) # Today

    (1..days).map.each do |i|
      puts "\n\n--- Date: #{Date.today + i}"
      BestMovies::Base.save_channel(group, Date.today + i)
    end

  end

end

