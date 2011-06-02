module OurKudos
  module Facebook

   def fb_post!(message, name=DEFAULT_FB_POST_NAME,
          description="TODO", url=DEFAULT_SHARE_URL, img=DEFAULT_FB_SHARE_IMAGE)
          options = {'access_token' => facebook_auth.token,
               'message' => message,
               'link' => url,
               'picture' => img,
               'name' => name,
               'caption' => url,
               'description' => description
    }
    RestClient.post(URI.escape("https://graph.facebook.com/me/feed/"), options)
  end

    def auth

    end

  end
end