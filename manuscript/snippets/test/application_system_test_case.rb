require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::RecordIdentifier
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1200, 1000 ]

  Capybara.default_max_wait_time = 10

  teardown do
    errors = page.driver.browser.logs.get(:browser).select { |entry| entry.level == "SEVERE" && !entry.message.include?("422") }
    puts errors.map(&:message) if errors.any?
  end

  setup do
    visit new_session_path
    fill_in "email_address", with: users(:one).email_address
    fill_in "password", with: "password"
    click_on "Sign in"
    assert_selector "h1", text: "タスク"
    assert_current_path root_path
    assert_selector "turbo-cable-stream-source[connected]", visible: :all
  end
end
