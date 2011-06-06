class FacebookKudoPostJob < Struct.new(:kudo)
  def perform
    kudo.author.post_facebook_kudo kudo
  end
end