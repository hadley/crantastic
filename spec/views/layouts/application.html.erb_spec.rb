require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "Application layout" do

  it "should set proper RPX Now token_url for development" do
    silence_warnings do
      APP_CONFIG =
        YAML.load_file("#{RAILS_ROOT}/config/settings.yml")["development"].symbolize_keys
    end
    render 'layouts/application'
    response.body.should match(/RPXNOW.token_url = "http:\/\/localhost:3000\/session\/rpx_token/)
  end

  it "should set proper RPX Now token_url for production" do
    silence_warnings do
      APP_CONFIG =
        YAML.load_file("#{RAILS_ROOT}/config/settings.yml")["production"].symbolize_keys
    end
    render 'layouts/application'
    response.body.should match(/RPXNOW.token_url = "http:\/\/crantastic.org\/session\/rpx_token/)
  end

end
