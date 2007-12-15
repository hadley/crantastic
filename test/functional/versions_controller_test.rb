require File.dirname(__FILE__) + '/../test_helper'

class VersionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:version)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_version
    assert_difference('Version.count') do
      post :create, :version => { }
    end

    assert_redirected_to version_path(assigns(:version))
  end

  def test_should_show_version
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_version
    put :update, :id => 1, :version => { }
    assert_redirected_to version_path(assigns(:version))
  end

  def test_should_destroy_version
    assert_difference('Version.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to version_path
  end
end
