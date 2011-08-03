namespace :database do
  task :count_comments => :environment do
    Kudo.count_comments!
  end
end