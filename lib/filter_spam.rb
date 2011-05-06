module FilterSpam
  require "filter_spam/configuration"
  require "filter_spam/instance_methods"

  mattr_accessor :configuration

  def self.configure
    self.configuration ||= FilterSpam::Configuration.new
    yield(configuration) if block_given?
  end

  extend ActiveSupport::Concern

  included do
    scope :ham,   where(:spam => false)
    scope :spam,  where(:spam => true)

    # setup default configuration
    FilterSpam.configure

    before_validation(:on => :create) do |inquiry|
      inquiry.catch_spam
    end
  end
end
