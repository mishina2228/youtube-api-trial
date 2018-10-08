require "application_system_test_case"

class ChannelStatusesTest < ApplicationSystemTestCase
  setup do
    @channel_status = channel_statuses(:one)
  end

  test "visiting the index" do
    visit channel_statuses_url
    assert_selector "h1", text: "Channel Statuses"
  end

  test "creating a Channel status" do
    visit channel_statuses_url
    click_on "New Channel Status"

    fill_in "Channel", with: @channel_status.channel_id
    fill_in "subscriber Count", with: @channel_status.subscriber_count
    fill_in "Video Count", with: @channel_status.video_count
    fill_in "View Count", with: @channel_status.view_count
    click_on "Create Channel status"

    assert_text "Channel status was successfully created"
    click_on "Back"
  end

  test "updating a Channel status" do
    visit channel_statuses_url
    click_on "Edit", match: :first

    fill_in "Channel", with: @channel_status.channel_id
    fill_in "subscriber Count", with: @channel_status.subscriber_count
    fill_in "Video Count", with: @channel_status.video_count
    fill_in "View Count", with: @channel_status.view_count
    click_on "Update Channel status"

    assert_text "Channel status was successfully updated"
    click_on "Back"
  end

  test "destroying a Channel status" do
    visit channel_statuses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Channel status was successfully destroyed"
  end
end
