class Inquiry < ActiveRecord::Base
  include ::FiltersSpam

  FiltersSpam.configure do |c|
    c.use_recaptcha = true
  end
end
