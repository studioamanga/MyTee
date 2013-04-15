require 'test_helper'

class TshirtsControllerTest < ActionController::TestCase
  setup do
    @tshirt = tshirts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tshirts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tshirt" do
    assert_difference('Tshirt.count') do
      post :create, :tshirt => { :color => @tshirt.color, :condition => @tshirt.condition, :image_url => @tshirt.image_url, :name => @tshirt.name, :note => @tshirt.note, :rating => @tshirt.rating, :size => @tshirt.size, :tags => @tshirt.tags }
    end

    assert_redirected_to tshirt_path(assigns(:tshirt))
  end

  test "should show tshirt" do
    get :show, :id => @tshirt
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @tshirt
    assert_response :success
  end

  test "should update tshirt" do
    put :update, :id => @tshirt, :tshirt => { :color => @tshirt.color, :condition => @tshirt.condition, :image_url => @tshirt.image_url, :name => @tshirt.name, :note => @tshirt.note, :rating => @tshirt.rating, :size => @tshirt.size, :tags => @tshirt.tags }
    assert_redirected_to tshirt_path(assigns(:tshirt))
  end

  test "should destroy tshirt" do
    assert_difference('Tshirt.count', -1) do
      delete :destroy, :id => @tshirt
    end

    assert_redirected_to tshirts_path
  end
end
