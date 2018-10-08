require "application_system_test_case"

class SystemSettingsTest < ApplicationSystemTestCase
  setup do
    @system_setting = system_settings(:one)
  end

  test "visiting the index" do
    visit system_settings_url
    assert_selector "h1", text: "System Settings"
  end

  test "creating a System setting" do
    visit system_settings_url
    click_on "New System Setting"

    fill_in "Api Key", with: @system_setting.api_key
    click_on "Create System setting"

    assert_text "System setting was successfully created"
    click_on "Back"
  end

  test "updating a System setting" do
    visit system_settings_url
    click_on "Edit", match: :first

    fill_in "Api Key", with: @system_setting.api_key
    click_on "Update System setting"

    assert_text "System setting was successfully updated"
    click_on "Back"
  end

  test "destroying a System setting" do
    visit system_settings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "System setting was successfully destroyed"
  end
end
