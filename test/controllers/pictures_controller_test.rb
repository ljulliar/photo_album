require 'test_helper'

class PicturesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pictures_new_url
    assert_response :success
  end

  test "should get create" do
    get pictures_create_url
    assert_response :success
  end

  test "should get delete" do
    get pictures_delete_url
    assert_response :success
  end

  test "should get list" do
    get pictures_list_url
    assert_response :success
  end
end
