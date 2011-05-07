module FilterSpam
  module Recaptcha
    require "filter_spam/recaptcha/recaptcha_helper"
    require "filter_spam/recaptcha/validator"

    extend ActiveSupport::Concern

    included do
      attr_accessor :recaptcha_challenge_field, :recaptcha_response_field

      before_validation :validate_recaptcha
    end

    module InstanceMethods
      protected
        def validate_recaptcha
          unless FilterSpam::Recaptcha::Validator.validate_recaptcha(recaptcha_challenge_field,
                                                                     recaptcha_response_field)
            self.errors[:base] = "The CAPTCHA solution was incorrect."
          end
        end
    end
  end
end
