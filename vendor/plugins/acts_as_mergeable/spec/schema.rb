ActiveRecord::Schema.define :version => 0 do

create_table :mergeable_models, :force => true do |t|
    t.column :name, :string
    t.column :user_id, :string
  end

  create_table :not_mergeable_models, :force => true do |t|
    t.column :user_id, :integer
    t.column :name, :string
  end

  create_table :users do |u|
    u.column :id, :integer
    u.column :name, :integer
  end

end