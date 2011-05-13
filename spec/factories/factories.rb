Factory.sequence(:site_name) { |n| "site #{n}" }
Factory.sequence(:role_name) { |n| "Role #{n}" }
Factory.sequence(:admin_role_name) { |n| "Admin Role #{n}" }
Factory.sequence(:email)     { |n| "email#{n}@email.com" }

Factory.define :site do |u|
  s.name { Factory.next(:site_name) }
  s.protocol 'http'
  s.url 'onet.pl'
  s.description 'my site'
end

Factory.define :api_key do |k|
  k.key 'iDHZ0oRvQlZxWjQta1H6McUjE8ndGXDEWp8tUS70Ery13r13WdV7tXGJP23vRqsK'
  k.expires_at '2111-11-11'
end

Factory.define :authentication do |a|
  a.provider 'facebook'
  a.uid 'uid'
  a.token 'token'
end

Factory.define :identity do |i|
  i.identity 'my@email.com'
  i.identity_type 'email'
  i.is_primary false
end

Factory.define :user do |u|
  u.email { Factory.next(:email) }
  u.created_at '1999-11-11'
  u.confirmed_at '1999-11-11'
  u.first_name 'My name'
  u.last_name 'Last name'
  u.password 'somepass'
end

Factory.define :admin_user, :parent => :user do |u|
  u.roles {|roles| [roles.association(:admin_role)] }
end

Factory.define :admin_role, :class => "Role" do |r|
  r.name { Factory.next(:admin_role_name) }
end

Factory.define :role do |r|
  r.name { Factory.next(:role_name) }  
end
