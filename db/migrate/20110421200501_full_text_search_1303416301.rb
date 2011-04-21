class FullTextSearch1303416301 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS users_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index users_fts_idx
      ON users
      USING gin((to_tsvector('english', coalesce("users"."email", '') || ' ' || coalesce("users"."first_name", '') || ' ' || coalesce("users"."last_name", '') || ' ' || coalesce("users"."middle_name", ''))))
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS users_fts_idx
    eosql
  end
end
