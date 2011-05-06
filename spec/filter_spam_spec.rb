require "spec_helper"

describe FilterSpam do

  describe ".configure" do
    after { FilterSpam.configuration = FilterSpam::Configuration.new }

    it "allows to configure message field" do
      FilterSpam.configure { |c| c.message_field = :rspec }
      FilterSpam.configuration.message_field.should == :rspec
    end

    it "allows to configure email field" do
      FilterSpam.configure { |c| c.email_field = :rspec }
      FilterSpam.configuration.email_field.should == :rspec
    end

    it "allows to configure author field" do
      FilterSpam.configure { |c| c.author_field = :rspec }
      FilterSpam.configuration.author_field.should == :rspec
    end

    it "allows to configure other fields" do
      FilterSpam.configure { |c| c.other_fields = :rspec }
      FilterSpam.configuration.other_fields.should include(:rspec)
    end

    it "adds extra spam words to spam words list" do
      FilterSpam.configure { |c| c.extra_spam_words = "rspec" }
      FilterSpam.configuration.spam_words.should include("rspec")
    end
  end

end
