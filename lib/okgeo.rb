module OurKudos
  module OkGeo
    require "net/http"
    require "uri"
    require "json"

    def self.find_local_zip_codes(zip_code)
      url = "http://okgeo.rkudos.com/zip/#{zip_code}"
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      
      request = Net::HTTP::Get.new(url)
      response = http.request(request)
      JSON(response.body)
    end
  end
end
