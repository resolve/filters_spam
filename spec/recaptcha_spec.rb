require "spec_helper"

describe FiltersSpam::Recaptcha do

  before do
    class Inquiry
      include FiltersSpam::Recaptcha
    end
  end

  context "when included in class" do
    subject { Inquiry.new }
    it { should respond_to :recaptcha_challenge_field }
    it { should respond_to :recaptcha_challenge_field= }
    it { should respond_to :recaptcha_response_field }
    it { should respond_to :recaptcha_response_field= }
  end

end
