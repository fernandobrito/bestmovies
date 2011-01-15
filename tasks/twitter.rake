#encoding: utf-8

namespace :twitter do

  desc "Update Twitter status with the best movies"
  task :update do

    group = (ARGV.find { |arg| /^GROUP/ =~ arg }.split("=").last           if ARGV.find { |arg| /^GROUP/ =~ arg })     || "All"
    time = (ARGV.find { |arg| /^TIME/ =~ arg }.split("=").last             if ARGV.find { |arg| /^TIME/ =~ arg })      || "Night"
    top = (ARGV.find { |arg| /^TOP/ =~ arg }.split("=").last.to_i          if ARGV.find { |arg| /^TOP/ =~ arg })       || 2
    update_twitter = (ARGV.find { |arg| /^UPDATE/ =~ arg }.split("=").last if ARGV.find { |arg| /^UPDATE/ =~ arg })    || "false"
    date = (Time.parse(ARGV.find { |arg| /^DATE/ =~ arg }.split("=").last) if ARGV.find { |arg| /^DATE/ =~ arg })      || Time.now
    rating = (ARGV.find { |arg| /^RATING/ =~ arg }.split("=").last.to_f    if ARGV.find { |arg| /^RATING/ =~ arg })    || 0

    case time
    when "Dawn"
      begins = Time.parse(date.strftime("%m/%d/%Y 00:00"))
      time = "Madrugada"
    when "Morning"
      begins = Time.parse(date.strftime("%m/%d/%Y 06:00"))
      time = "Manhã"
    when "Afternoon"
      begins = Time.parse(date.strftime("%m/%d/%Y 12:00"))
      time = "Tarde"
    when "Night"
      begins = Time.parse(date.strftime("%m/%d/%Y 18:00"))
      time = "Noite"
    else
      raise "Time not found. Dawn | Morning | Afternoon | Night"
    end

    ends = begins + (60 * 60 * 6) # 6 hours later

    BestMovies::Twitter.update_with_best_movies_between(top, group, rating, begins, ends, time, update_twitter)
  end

end
