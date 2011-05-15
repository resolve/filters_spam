require "spec_helper"

describe FiltersSpam::Recaptcha do

  before do
    class Inquiry
      include FiltersSpam::Recaptcha
    end
  end

  let(:inquiry) { Inquiry.new }

  context "when included in a class" do
    subject { inquiry }
    it { should respond_to :recaptcha_challenge_field }
    it { should respond_to :recaptcha_challenge_field= }
    it { should respond_to :recaptcha_response_field }
    it { should respond_to :recaptcha_response_field= }
  end

  context "validation" do
    context "when invalid recaptcha" do
      it "sets an error message on inquiry instance" do
        FiltersSpam::Recaptcha::Validator.stub(:validate_recaptcha).and_return("false", "error")
        inquiry.stub(:catch_spam).and_return(true)
        inquiry.save
        inquiry.errors.should_not be_empty
      end
    end

    context "when valid recaptcha" do
      it "doesn't set an error message on inquiry instance" do
        FiltersSpam::Recaptcha::Validator.stub(:validate_recaptcha).and_return("true", "...")
        inquiry.stub(:catch_spam).and_return(true)
        inquiry.save
        inquiry.errors.should be_empty
      end
    end
  end

end
