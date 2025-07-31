require "application_system_test_case"

class TrackersTest < ApplicationSystemTestCase
  setup do
    @tracker = trackers(:one)
  end

  test "visiting the index" do
    visit trackers_url
    assert_selector "h1", text: "Trackers"
  end

  test "should create tracker" do
    visit trackers_url
    click_on "New tracker"

    fill_in "Amount", with: @tracker.amount
    fill_in "Brand", with: @tracker.brand
    fill_in "Come back to eat time", with: @tracker.come_back_to_eat_time
    fill_in "Date", with: @tracker.date
    fill_in "Description", with: @tracker.description
    fill_in "Favorite score", with: @tracker.favorite_score
    fill_in "Feed time", with: @tracker.feed_time
    fill_in "Frequency", with: @tracker.frequency
    fill_in "Hungry", with: @tracker.hungry
    fill_in "Left amount", with: @tracker.left_amount
    fill_in "Love", with: @tracker.love
    fill_in "Note", with: @tracker.note
    fill_in "Pet", with: @tracker.pet_id
    fill_in "Result", with: @tracker.result
    fill_in "Total ate amount", with: @tracker.total_ate_amount
    fill_in "Transformed date", with: @tracker.transformed_date
    fill_in "Transformed time", with: @tracker.transformed_time
    fill_in "Weight", with: @tracker.weight
    click_on "Create Tracker"

    assert_text "Tracker was successfully created"
    click_on "Back"
  end

  test "should update Tracker" do
    visit tracker_url(@tracker)
    click_on "Edit this tracker", match: :first

    fill_in "Amount", with: @tracker.amount
    fill_in "Brand", with: @tracker.brand
    fill_in "Come back to eat time", with: @tracker.come_back_to_eat_time.to_s
    fill_in "Date", with: @tracker.date
    fill_in "Description", with: @tracker.description
    fill_in "Favorite score", with: @tracker.favorite_score
    fill_in "Feed time", with: @tracker.feed_time.to_s
    fill_in "Frequency", with: @tracker.frequency
    fill_in "Hungry", with: @tracker.hungry
    fill_in "Left amount", with: @tracker.left_amount
    fill_in "Love", with: @tracker.love
    fill_in "Note", with: @tracker.note
    fill_in "Pet", with: @tracker.pet_id
    fill_in "Result", with: @tracker.result
    fill_in "Total ate amount", with: @tracker.total_ate_amount
    fill_in "Transformed date", with: @tracker.transformed_date
    fill_in "Transformed time", with: @tracker.transformed_time.to_s
    fill_in "Weight", with: @tracker.weight
    click_on "Update Tracker"

    assert_text "Tracker was successfully updated"
    click_on "Back"
  end

  test "should destroy Tracker" do
    visit tracker_url(@tracker)
    click_on "Destroy this tracker", match: :first

    assert_text "Tracker was successfully destroyed"
  end
end
