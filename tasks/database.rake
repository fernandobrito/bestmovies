require  'dm-migrations'

namespace :database do
  task :default => :create

  desc "Creates the database"
  task :create do
    DataMapper.auto_migrate!
  end

  desc "Fill in with seed data (not necessary anymore)"
  task :seed do
    ["HBO", "HBO 2", "HBO Family", "HBO Family e", "HBO Plus", "HBO Plus e", "HBO HD", "Telecine Action", "Telecine Cult",
    "Telecine Light", "Telecine Pipoca", "Telecine Premium", "Telecine HD", "Telecine Pipoca HD"].each do |channel|
      Channel.create(:name => channel)
    end
  end

end

