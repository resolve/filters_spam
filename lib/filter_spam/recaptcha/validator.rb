require "net/http"
require "uri"

module FilterSpam
  module Recaptcha
    module Validator
      def self.validate_recaptcha(challenge, response)
        uri = URI.parse("http://www.google.com/recaptcha/api/verify")
        params = {
          :privatekey => FilterSpam.configuration.recaptcha_private_key,
          :challenge => challenge,
          :response => response
        }

        status = Net::HTTP.post_form(uri, params).body.split("\n").first

        if status == "true"
          true
        elsif status == "false"
          false
        end
      end
    end
  end
end
