require "spec_helper"

describe FiltersSpam do

  describe ".configure" do
    after { FiltersSpam.configuration = FiltersSpam::Configuration.new }

    it "allows to configure message field" do
      FiltersSpam.configure { |c| c.message_field = :rspec }
      FiltersSpam.configuration.message_field.should == :rspec
    end

    it "allows to configure email field" do
      FiltersSpam.configure { |c| c.email_field = :rspec }
      FiltersSpam.configuration.email_field.should == :rspec
    end

    it "allows to configure author field" do
      FiltersSpam.configure { |c| c.author_field = :rspec }
      FiltersSpam.configuration.author_field.should == :rspec
    end

    it "allows to configure other fields" do
      FiltersSpam.configure { |c| c.other_fields = :rspec }
      FiltersSpam.configuration.other_fields.should include(:rspec)
    end

    it "adds extra spam words to spam words list" do
      FiltersSpam.configure { |c| c.extra_spam_words = "rspec" }
      FiltersSpam.configuration.spam_words.should include("rspec")
    end
  end

end
