require "test_helper"

class CourtOwnersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get court_owners_index_url
    assert_response :success
  end

  test "should get show" do
    get court_owners_show_url
    assert_response :success
  end

  test "should get new" do
    get court_owners_new_url
    assert_response :success
  end

  test "should get create" do
    get court_owners_create_url
    assert_response :success
  end

  test "should get edit" do
    get court_owners_edit_url
    assert_response :success
  end

  test "should get update" do
    get court_owners_update_url
    assert_response :success
  end

  test "should get destroy" do
    get court_owners_destroy_url
    assert_response :success
  end
end
