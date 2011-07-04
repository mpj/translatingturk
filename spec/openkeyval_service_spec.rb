require './services/openkeyval_service'
require 'net/http'

describe OpenKeyValueService, "#write" do

  it "should post to openkeyval.org" do
    Net::HTTP.should_receive(:post_form) { | uri, params |
      uri.class.should == URI::HTTP
      uri.to_s.should == 'http://api.openkeyval.org/key123'
      params[:data].should == 'value456'
    }
    OpenKeyValueService.write('key123', 'value456')
  end

end

describe OpenKeyValueService, "#read" do

  it "should GET from openkeyval.org" do
    Net::HTTP.should_receive(:get) { |uri|
      uri.class.should == URI::HTTP
      uri.to_s.should == 'http://api.openkeyval.org/key123'
      "value678"
    }
    OpenKeyValueService.read('key123').should == 'value678'
  end

end