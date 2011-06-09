class TwitterKudoPostJob < Struct.new(:twitter_kudo)
  def perform
    kudo = twitter_kudo.kudo
    twitter_kudo.response = kudo.author.post_twitter_kudo kudo
    twitter_kudo.save
  end
end