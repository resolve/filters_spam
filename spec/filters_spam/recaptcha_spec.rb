require "spec_helper"

describe FiltersSpam::Recaptcha do
  context "when included in a class" do
    class Inquiry
      include FiltersSpam::Recaptcha
    end

    subject { Inquiry.new }
    it { should respond_to :recaptcha_challenge_field }
    it { should respond_to :recaptcha_challenge_field= }
    it { should respond_to :recaptcha_response_field }
    it { should respond_to :recaptcha_response_field= }
  end
end