require File.dirname(__FILE__) + '/../test_helper'

class AuthorsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:author)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_author
    assert_difference('Author.count') do
      post :create, :author => { }
    end

    assert_redirected_to author_path(assigns(:author))
  end

  def test_should_show_author
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_author
    put :update, :id => 1, :author => { }
    assert_redirected_to author_path(assigns(:author))
  end

  def test_should_destroy_author
    assert_difference('Author.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to author_path
  end
end
