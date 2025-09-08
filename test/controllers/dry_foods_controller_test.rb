require "test_helper"

class DryFoodsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get dry_foods_index_url
    assert_response :success
  end

  test "should get show" do
    get dry_foods_show_url
    assert_response :success
  end

  test "should get add" do
    get dry_foods_add_url
    assert_response :success
  end
end