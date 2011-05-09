class Inquiry < ActiveRecord::Base
  include ::FilterSpam

  FilterSpam.configure do |c|
    c.use_recaptcha = true
  end
end
