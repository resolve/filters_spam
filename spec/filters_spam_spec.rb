require "spec_helper"

describe FiltersSpam do

  describe ".configure" do
    it "is a module method" do
      FiltersSpam.should respond_to :configure
    end
  end

end
