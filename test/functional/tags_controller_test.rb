require File.dirname(__FILE__) + '/../test_helper'

class TagsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:tag)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_tag
    assert_difference('Tag.count') do
      post :create, :tag => { }
    end

    assert_redirected_to tag_path(assigns(:tag))
  end

  def test_should_show_tag
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_tag
    put :update, :id => 1, :tag => { }
    assert_redirected_to tag_path(assigns(:tag))
  end

  def test_should_destroy_tag
    assert_difference('Tag.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to tag_path
  end
end
