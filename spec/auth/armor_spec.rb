require "spec_helper"

RSpec.describe AuthArmor do
  it "has a version number" do
    expect(AuthArmor::VERSION).not_to be nil
  end
  
  context "with valid credentials" do
    it "returns scope not allowed for unaccepted scope" do
      expect{ 
        
       # binding.pry
        
        AuthArmor::Client.new(scope:"autharmor scope" , client_id:"okay" , client_secret:"test" )
    }.to raise_error(RuntimeError,/Scope not allowed./)
    end
    
    it "does not return scope not allowed for accepted scope" do
      expect{ 
        AuthArmor::Client.new(scope:"aarmor.api.request_auth" , client_id:"okay" , client_secret:"test" )
    }.not_to raise_error(RuntimeError,/Scope not allowed./)
    end
  end
end
