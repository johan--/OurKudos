require 'ourkudos/server/response_codes'
require 'ourkudos/validators/remote_resource_validator'
require 'ourkudos/acts/client'
require 'ourkudos/acts/resource'
require 'ourkudos/strategies/strategy'
ActiveRecord::Base.send :include, OurKudos::Acts::Client
ActiveRecord::Base.send :include, OurKudos::Acts::Resource

class Hash
  def recursive_find_by_key key
    stack = [self]
    while (to_search = stack.pop)
      to_search.each do |k, v|
        return v if (k == key)
        if (v.respond_to?(:recursive_find_by_key))
          stack << v
        end
      end
    end
  end
end