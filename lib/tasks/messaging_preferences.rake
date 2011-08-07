namespace :messaging_preferences do
  task :generate => :environment  do
    users_with_prefs = User.find_by_sql("SELECT DISTINCT u.id from messaging_preferences mp JOIN users u on u.id = mp.user_id")
    users_with_prefs.collect!{|u| u.id }
    #users_with_prefs = users_with_prefs.join(", ")
    users_with_prefs = 0 if users_with_prefs.empty?
    users_without_prefs = User.where("id NOT IN (?)", users_with_prefs)

    users_without_prefs.each do |user|
      MessagingPreference.create(:user_id => user.id)
    end
  end
end

