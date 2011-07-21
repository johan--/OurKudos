class AddSystemKudosCacheToKudos < ActiveRecord::Migration
  def change
    add_column :kudos, :system_kudos_recipients_cache, :string, :default => [].to_yaml
    #update existing cache

    Kudo.all.each do |kudo|
      kudo.system_kudos_recipients_cache << kudo.kudo_copies.map(&:recipient_id).compact.flatten.uniq
      kudo.system_kudos_recipients_cache = kudo.system_kudos_recipients_cache.flatten
      kudo.save :validate => false
    end

  end

end