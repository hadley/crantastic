require File.dirname(__FILE__) + '/../test_helper'

class ReviewsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:review)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_review
    assert_difference('Review.count') do
      post :create, :review => { }
    end

    assert_redirected_to review_path(assigns(:review))
  end

  def test_should_show_review
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end

  def test_should_update_review
    put :update, :id => 1, :review => { }
    assert_redirected_to review_path(assigns(:review))
  end

  def test_should_destroy_review
    assert_difference('Review.count', -1) do
      delete :destroy, :id => 1
    end

    assert_redirected_to review_path
  end
end
