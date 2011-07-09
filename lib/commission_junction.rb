require "net/http"

module OurKudos
  module CommissionJunction

    
    def self.api_call(merchant_code, affiliate_code)
      #needs refactoring, maybe into its own module
      merchant = merchant_code.strip
      affiliate = affiliate_code.strip
      begin
        developer_key = '0092a736a8ad08794e9fa060471488838dc9dae896b7b413b3e64691d7b34842306d6a01653dd628eed4ac2fb089186aa94a5ef09747178ce9357af458712c2a87/00865bf264e95ac920f278519cedc0009f07dfaa966329f59f2d8b5c14fde966d1637db8e7beddcc4c75b77d96e751699fb18a7e3808d27ee80a206c5da5c1a441'

        uri = URI.parse("https://product-search.api.cj.com/v2/product-search?advertiser-sku=#{affiliate}&advertiser-ids=#{merchant}&website-id=5253557")

        headers = {'authorization' => developer_key}

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new("https://product-search.api.cj.com/v2/product-search?advertiser-sku=#{affiliate}&advertiser-ids=#{merchant}&website-id=5253557")
        request.add_field('authorization', developer_key)

        response = http.request(request)

          return response.body
        rescue URI::InvalidURIError
          return "bad uri"
        end
      end

  end
end
#puts CommissionJunction.api_call("1987828", "OSF33D707")

