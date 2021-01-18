require "auth_armor"

RSpec.describe Auth::Armor do
  it "has a version number" do
    expect(Auth::Armor::VERSION).not_to be nil
  end

  #it "does something useful" do
  #  expect(false).to eq(true)
  #end

  describe connect do
  it "Connects successfully" do
    expect{200}.to output{"Connection successfull"}.to_stdout
  end  
  it "invalid connection" do 
    expect{400}.to output{"Error"}.to_stdout
  end
  it "fails" do
    expect{response.to_str}.to output{"Connection failed"}.to_stdout
  end

describe auth-requests do 
  it "returns an empty response" do
   expect(auth-requests("")).to be_empty
 end  
  it "returns a page not found" do
     expect{400}.to output("error").to_stderr
 end
  it "Adds a client successfully" do
     expect { 200 }.to output("Operation Successful").to_stdout
 end

describe  invite_request do
  it "has a valid invite request" do
   expect( invite_request).not_to be_nil
 end

describe generate_qr_code do
  it "has a valid qr code" do
   expect(generate_qr_code).not_to be_nil
  end
 end
end