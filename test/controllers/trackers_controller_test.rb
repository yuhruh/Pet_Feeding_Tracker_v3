require "test_helper"

class TrackersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tracker = trackers(:one)
  end

  test "should get index" do
    get trackers_url
    assert_response :success
  end

  test "should get new" do
    get new_tracker_url
    assert_response :success
  end

  test "should create tracker" do
    assert_difference("Tracker.count") do
      post trackers_url, params: { tracker: { amount: @tracker.amount, brand: @tracker.brand, come_back_to_eat_time: @tracker.come_back_to_eat_time, date: @tracker.date, description: @tracker.description, favorite_score: @tracker.favorite_score, feed_time: @tracker.feed_time, frequency: @tracker.frequency, hungry: @tracker.hungry, left_amount: @tracker.left_amount, love: @tracker.love, note: @tracker.note, pet_id: @tracker.pet_id, result: @tracker.result, total_ate_amount: @tracker.total_ate_amount, transformed_date: @tracker.transformed_date, transformed_time: @tracker.transformed_time, weight: @tracker.weight } }
    end

    assert_redirected_to tracker_url(Tracker.last)
  end

  test "should show tracker" do
    get tracker_url(@tracker)
    assert_response :success
  end

  test "should get edit" do
    get edit_tracker_url(@tracker)
    assert_response :success
  end

  test "should update tracker" do
    patch tracker_url(@tracker), params: { tracker: { amount: @tracker.amount, brand: @tracker.brand, come_back_to_eat_time: @tracker.come_back_to_eat_time, date: @tracker.date, description: @tracker.description, favorite_score: @tracker.favorite_score, feed_time: @tracker.feed_time, frequency: @tracker.frequency, hungry: @tracker.hungry, left_amount: @tracker.left_amount, love: @tracker.love, note: @tracker.note, pet_id: @tracker.pet_id, result: @tracker.result, total_ate_amount: @tracker.total_ate_amount, transformed_date: @tracker.transformed_date, transformed_time: @tracker.transformed_time, weight: @tracker.weight } }
    assert_redirected_to tracker_url(@tracker)
  end

  test "should destroy tracker" do
    assert_difference("Tracker.count", -1) do
      delete tracker_url(@tracker)
    end

    assert_redirected_to trackers_url
  end
end