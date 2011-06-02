module OurKudos
  module Facebook

    def authenticate_with authentication
      user = FbGraph::User.new 'matake', :access_token => YOUR_ACCESS_TOKEN)
    end

    def auth

    end

  end
end