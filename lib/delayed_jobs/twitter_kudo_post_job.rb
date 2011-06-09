class TwitterKudoPostJob < Struct.new(:twitter_kudo)
  def perform
    twitter_kudo.post_me!
  end
end