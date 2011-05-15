module FiltersSpam
  extend ActiveSupport::Concern

  require "filters_spam/configuration"
  require "filters_spam/instance_methods"
  require "filters_spam/recaptcha"

  mattr_accessor :configuration

  def self.configure
    self.configuration ||= FiltersSpam::Configuration.new
    yield(configuration) if block_given?
  end

  included do
    scope :ham,   where(:spam => false)
    scope :spam,  where(:spam => true)

    # setup default configuration
    FiltersSpam.configure

    # load recpatcha stuff if needed
    include FiltersSpam::Recaptcha if FiltersSpam.configuration.use_recaptcha

    before_validation :catch_spam, :on => :create
  end
end
