require File.dirname(__FILE__) + '/../test_helper'

class PackagesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:package)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_package
    assert_difference('Package.count') do
      post :create, :package => { }
    end

    assert_redirected_to package_path(assigns(:package))
  end

  def test_should_show_package
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_package
    put :update, :id => 1, :package => { }
    assert_redirected_to package_path(assigns(:package))
  end

  def test_should_destroy_package
    assert_difference('Package.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to package_path
  end
end
