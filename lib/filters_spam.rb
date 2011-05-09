module FiltersSpam
  require "filters_spam/configuration"
  require "filters_spam/instance_methods"

  autoload :Recaptcha, "filters_spam/recaptcha"

  mattr_accessor :configuration

  def self.configure
    self.configuration ||= FiltersSpam::Configuration.new
    yield(configuration) if block_given?
  end

  extend ActiveSupport::Concern

  included do
    scope :ham,   where(:spam => false)
    scope :spam,  where(:spam => true)

    # setup default configuration
    FiltersSpam.configure

    # load recpatcha stuff if needed
    include FiltersSpam::Recaptcha if FiltersSpam.configuration.use_recaptcha

    before_validation(:on => :create) do |inquiry|
      inquiry.catch_spam
    end
  end
end
