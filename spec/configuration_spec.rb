require "spec_helper"

describe FiltersSpam::Configuration do

  let(:config) { FiltersSpam::Configuration.new }

  it "configures message field" do
    config.message_field = :rspec
    config.message_field.should == :rspec
  end

  it "configures email field" do
    config.email_field = :rspec
    config.email_field.should == :rspec
  end

  it "configures author field" do
    config.author_field = :rspec
    config.author_field.should == :rspec
  end

  it "configures other fields" do
    config.other_fields = :rspec
    config.other_fields.should include(:rspec)
  end

  it "adds extra spam words to spam words list" do
    config.extra_spam_words = "rspec"
    config.spam_words.should include("rspec")
  end

  it "configures recpatcha usage" do
    config.use_recaptcha = true
    config.use_recaptcha.should == true
  end

  it "configures recaptcha public key" do
    config.recaptcha_public_key = "777"
    config.recaptcha_public_key.should == "777"
  end

  it "configures recaptcha private key" do
    config.recaptcha_private_key = "777"
    config.recaptcha_private_key.should == "777"
  end

end
