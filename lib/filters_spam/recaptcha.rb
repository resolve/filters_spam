module FiltersSpam
  module Recaptcha
    require "filters_spam/recaptcha/recaptcha_helper"
    require "filters_spam/recaptcha/validator"

    extend ActiveSupport::Concern

    included do
      attr_accessor :recaptcha_challenge_field, :recaptcha_response_field

      before_validation :validate_recaptcha
    end

    module InstanceMethods
      protected
        def validate_recaptcha
          status, error = FiltersSpam::Recaptcha::Validator.validate_recaptcha(recaptcha_challenge_field,
                                                                               recaptcha_response_field)
          # error string later could be used for I18n
          self.errors[:base] = error if status == "false"
        end
    end
  end
end
