require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include AuthHelper

describe RatingsController do

  it "should require login" do
    post :create
    response.should be_redirect
  end

  it "should create new ratings" do
    login_as_user(:id => 1, :login => "test")
    package = mock_model(Package, :id => 1)
    Package.should_receive(:find_by_name).with("aaMI").and_return(package)
    @current_user.should_receive(:rate!).with(package, 5, "overall")
    post :create, :package_id => "aaMI", :rating => 5, :aspect => "overall"
  end

end
