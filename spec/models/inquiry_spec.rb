require "spec_helper"

describe Inquiry do

  let(:inquiry) { Inquiry.new }

  describe "scopes" do
    it "adds ham scope when included" do
      Inquiry.should respond_to :ham
    end

    it "adds spam scope when included" do
      Inquiry.should respond_to :spam
    end
  end

  describe "#ham?" do
    it "returns true if inquiry is not spam" do
      inquiry.stub(:spam?).and_return(false)
      inquiry.ham?.should == true
    end

    it "returns false if inquiry is spam" do
      inquiry.stub(:spam?).and_return(true)
      inquiry.ham?.should == false
    end
  end

  describe "#ham!" do
    it "sets spam to false" do
      inquiry.ham!
      inquiry.ham?.should == true
    end
  end

  describe "#spam!" do
    it "sets spam to true" do
      inquiry.spam!
      inquiry.ham?.should == false
    end
  end

  describe "#catch_spam" do
    def setup
      inquiry.author = "The RSpec guy"
      inquiry.message = "This is completely clean message."
    end

    def save_and_assume_spam
      inquiry.save
      inquiry.ham?.should == false
    end

    context "inquiry is not marked as spam if" do
      specify "all fields are clean" do
        setup
        inquiry.save
        inquiry.ham?.should == true
      end
    end

    context "inquiry is marked as spam if" do
      specify "message containts > 2 links" do
        setup
        inquiry.message = "http://thisisspam.com http://thisisspam.com http://thisisspam.com"
        save_and_assume_spam
      end

      specify "message length < 20 and contains links" do
        setup
        inquiry.message = "This message is http://spam!"
        save_and_assume_spam
      end

      specify "message contains spam words" do
        setup
        inquiry.message = "valeofglamorganconservatives viagra vioxx xanax zolus"
        save_and_assume_spam
      end

      specify "author contains spam words" do
        setup
        inquiry.author = "valeofglamorganconservatives viagra vioxx xanax zolus"
        save_and_assume_spam
      end

      specify "other fields contains spam words" do
        setup

        class Inquiry
          FilterSpam.configure {|c| c.other_fields = :phone}
        end
        
        inquiry.phone = "valeofglamorganconservatives viagra vioxx xanax zolus"
        save_and_assume_spam
      end

      suspect_url_parts = %w(.html .info ? & free)
      suspect_url_parts.each do |url_part|
        specify "message contains url with #{url_part} in it" do
          setup
          inquiry.message = "http://randomrandomrandomrandom#{url_part}"
          save_and_assume_spam
        end
      end

      suspect_tlds = %w(de pl cn)
      suspect_tlds.each do |tld|
        specify "message contains url with #{tld} tld" do
          setup
          inquiry.message = "http://randomrandomrandomrandom.#{tld}"
          save_and_assume_spam
        end
      end

      specify "author field contains link" do
        setup
        inquiry.author = "http://this.is.spam!"
        save_and_assume_spam
      end

      lame_message_starts = %w(interesting sorry nice cool)
      lame_message_starts.each do |lame|
        specify "message starts with '#{lame}'" do
          setup
          inquiry.message = "#{lame} lorem ipsum dolor sit amet"
          save_and_assume_spam
        end
      end

      specify "same content as previous message" do
        setup
        inquiry.save
        inq = Inquiry.create(:author => "The RSpec guy",
                             :message => "This is completely clean message.")
        inq.ham?.should == false
      end

      specify "previous message from same email is spam" do
        setup
        inquiry.message = "http://this.is.another.spam.com"
        inquiry.email = "spam@me.com"
        inquiry.save
        inq = Inquiry.create(:author => "The RSpec guy",
                             :message => "This is another completely clean message.",
                             :email => "spam@me.com")
        inq.ham?.should == false
      end
    end
  end
  
end
